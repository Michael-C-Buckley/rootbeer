# shellcheck shell=sh
set -eu

socket="$HOME/.ssh/agent/openssh.sock"
legacy_socket="$HOME/.ssh/agent/custom.sock"
key_directory="$HOME/.ssh/sk"
askpass="$HOME/.local/libexec/rootbeer/ssh-askpass"
agent_pid=""

for candidate in \
	"$HOME/.local/state/rootbeer/profiles/default/current/bin" \
	"$HOME/.local/state/rootbeer/profiles/user/current/bin" \
	/opt/homebrew/opt/openssh/bin \
	/usr/local/opt/openssh/bin
do
	if [ -x "$candidate/ssh-agent" ] && [ -x "$candidate/ssh-add" ]; then
		openssh_bin=$candidate
		break
	fi
done

if [ -z "${openssh_bin:-}" ]; then
	echo "OpenSSH is not installed by Rootbeer or Homebrew" >&2
	exit 1
fi

# Pin the agent, its client, and its helpers to one package generation. The
# Rootbeer OpenSSH build resolves helper names through PATH, so launching the
# agent with launchd's system-only PATH prevents FIDO signing from finding
# ssh-sk-helper. Resolving the selected agent also avoids mixing generations if
# a profile is updated while this agent is still running.
ssh_agent=$(/bin/realpath "$openssh_bin/ssh-agent")
case "$ssh_agent" in
	*/bin/ssh-agent) openssh_root=${ssh_agent%/bin/ssh-agent} ;;
	*)
		echo "could not determine the OpenSSH package root from $ssh_agent" >&2
		exit 1
		;;
esac

ssh_add="$openssh_root/bin/ssh-add"
ssh_sk_helper="$openssh_root/libexec/ssh-sk-helper"

if [ ! -x "$ssh_add" ]; then
	echo "ssh-add is missing from $openssh_root/bin" >&2
	exit 1
fi

if [ ! -x "$ssh_sk_helper" ]; then
	echo "ssh-sk-helper is missing from $openssh_root/libexec" >&2
	exit 1
fi

export PATH="$openssh_root/libexec:$openssh_root/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export SSH_AUTH_SOCK="$socket"

cleanup() {
	trap - EXIT INT TERM HUP

	if [ -n "$agent_pid" ]; then
		/bin/kill "$agent_pid" 2>/dev/null || true
		wait "$agent_pid" 2>/dev/null || true
	fi

	/bin/rm -f "$legacy_socket" "$socket"
}

trap cleanup EXIT
trap 'exit 0' INT TERM HUP

umask 077
/bin/mkdir -p "$(/usr/bin/dirname "$socket")"
/bin/chmod 700 "$(/usr/bin/dirname "$socket")"
/bin/rm -f "$legacy_socket" "$socket"

# OpenSSH uses askpass as a non-interactive notifier while a FIDO key is
# waiting for user presence. Force it because this LaunchAgent has no DISPLAY.
if [ -x "$askpass" ]; then
	export SSH_ASKPASS="$askpass"
	export SSH_ASKPASS_REQUIRE=force
fi

"$ssh_agent" -D -a "$socket" &
agent_pid=$!

attempts=0
while [ ! -S "$socket" ] && [ "$attempts" -lt 50 ]; do
	if ! /bin/kill -0 "$agent_pid" 2>/dev/null; then
		break
	fi

	attempts=$((attempts + 1))
	/bin/sleep 0.1
done

if [ ! -S "$socket" ]; then
	echo "ssh-agent did not create $socket" >&2
	exit 1
fi

/bin/ln -s "$(/usr/bin/basename "$socket")" "$legacy_socket"

# Make the stable socket available to subsequently launched GUI apps.
/bin/launchctl setenv SSH_AUTH_SOCK "$socket"

# Resident-key handles are not private key material. Signing still requires
# the attached security key and its user-presence check.
for key in "$key_directory"/id_*_sk_rk_*; do
	[ -f "$key" ] || continue
	case "$key" in
		*.pub) continue ;;
	esac

	if ! "$ssh_add" -q "$key"; then
		echo "could not load SSH security-key handle: $key" >&2
	fi
done

wait "$agent_pid"
