set -eu

label="local.rootbeer.ssh-agent"
domain="gui/$(/usr/bin/id -u)"
service="$domain/$label"
plist="$HOME/Library/LaunchAgents/$label.plist"
runner="$HOME/.local/libexec/rootbeer/ssh-agent"
socket="$HOME/.ssh/agent/openssh.sock"

bootout() {
	service_name=$1
	if /bin/launchctl print "$domain/$service_name" >/dev/null 2>&1; then
		/bin/launchctl bootout "$domain/$service_name"

		attempts=0
		while /bin/launchctl print "$domain/$service_name" >/dev/null 2>&1; do
			attempts=$((attempts + 1))
			if [ "$attempts" -ge 50 ]; then
				echo "timed out waiting for $service_name to unload" >&2
				return 1
			fi
			/bin/sleep 0.1
		done
	fi
}

load() {
	/usr/bin/plutil -lint "$plist" >/dev/null
	if [ ! -x "$runner" ]; then
		echo "ssh-agent runner is missing or not executable: $runner" >&2
		exit 1
	fi

	bootout "$label"
	/bin/launchctl enable "$service"
	/bin/launchctl bootstrap "$domain" "$plist"
}

case "${1:-status}" in
	switch)
		# Home Manager has used both labels. Disable them so an old plist cannot
		# start a second agent at the next login.
		for legacy_label in \
			org.nix-community.home.nixpkgs-fido-ssh-agent \
			org.nixos.nixpkgs-fido-ssh-agent
		do
			/bin/launchctl disable "$domain/$legacy_label"
			bootout "$legacy_label"
		done
		load
		;;
	restart)
		load
		;;
	stop)
		bootout "$label"
		if [ "$(/bin/launchctl getenv SSH_AUTH_SOCK 2>/dev/null || true)" = "$socket" ]; then
			/bin/launchctl unsetenv SSH_AUTH_SOCK
		fi
		;;
	status)
		/bin/launchctl print "$service"
		;;
	*)
		echo "usage: rootbeer-ssh-agent {status|switch|restart|stop}" >&2
		exit 2
		;;
esac
