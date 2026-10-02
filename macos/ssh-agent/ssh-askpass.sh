set -eu

prompt=${1:-OpenSSH request}
sound_volume=${SSH_TOUCH_SOUND_VOLUME:-0.2}

request_origin() {
	origin_socket=${SSH_AUTH_SOCK:-"$HOME/.ssh/agent/openssh.sock"}
	[ -S "$origin_socket" ] || return 0

	origin_agent_pid=$(/usr/sbin/lsof -n -a -U "$origin_socket" 2>/dev/null |
		/usr/bin/awk 'NR > 1 { print $2; exit }')
	[ -n "$origin_agent_pid" ] || return 0

	origin_requester_pid=''
	for origin_endpoint in $(
		/usr/sbin/lsof -n -a -U -p "$origin_agent_pid" 2>/dev/null |
			/usr/bin/awk -v socket="$origin_socket" \
				'NR > 1 && $NF == socket && $6 ~ /^0x/ { print $6 }'
	); do
		origin_requester_pid=$(
			/usr/sbin/lsof -n -U 2>/dev/null |
				/usr/bin/awk -v peer="->$origin_endpoint" -v agent="$origin_agent_pid" \
					'NR > 1 && $NF == peer && $2 != agent { print $2; exit }'
		)
		[ -n "$origin_requester_pid" ] && break
	done
	[ -n "$origin_requester_pid" ] || return 0

	origin_command=$(/bin/ps -p "$origin_requester_pid" -o comm= 2>/dev/null |
		/usr/bin/sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
	origin_name=${origin_command##*/}
	[ -n "$origin_name" ] || return 0

	origin_parent_pid=$(/bin/ps -p "$origin_requester_pid" -o ppid= 2>/dev/null |
		/usr/bin/tr -d '[:space:]')
	origin_parent_command=$(/bin/ps -p "$origin_parent_pid" -o comm= 2>/dev/null |
		/usr/bin/sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
	origin_parent_name=${origin_parent_command##*/}

	case "$origin_parent_name" in
		''|launchd|sh|bash|zsh|rush|fish|env)
			printf '%s (PID %s)' "$origin_name" "$origin_requester_pid"
			;;
		*)
			printf '%s via %s (PID %s)' \
				"$origin_name" "$origin_parent_name" "$origin_requester_pid"
			;;
	esac
}

case "${SSH_ASKPASS_PROMPT:-}" in
	none)
		# OpenSSH uses the "none" hint for a transient FIDO touch notice.
		origin=$(request_origin)
		if [ -n "$origin" ]; then
			prompt=$(printf '%s\nRequested by %s' "$prompt" "$origin")
		fi

		# AppleScript notification sounds do not have a volume control, so post
		# silently and play the same chime separately at fractional gain.
		/usr/bin/afplay -v "$sound_volume" /System/Library/Sounds/Glass.aiff \
			>/dev/null 2>&1 &
		exec /usr/bin/osascript - "$prompt" <<'APPLESCRIPT'
on run argv
	display notification (item 1 of argv) with title "Touch your security key"
end run
APPLESCRIPT
		;;
	confirm)
		# Preserve ssh-add -c and other explicit key-use confirmations.
		exec /usr/bin/osascript - "$prompt" <<'APPLESCRIPT'
on run argv
	try
		display dialog (item 1 of argv) with title "OpenSSH confirmation" buttons {"Deny", "Allow"} default button "Allow" cancel button "Deny" with icon caution
		return "yes"
	on error number -128
		return "no"
	end try
end run
APPLESCRIPT
		;;
	*)
		# FIDO PIN and passphrase requests need a value on stdout.
		exec /usr/bin/osascript - "$prompt" <<'APPLESCRIPT'
on run argv
	try
		set response to display dialog (item 1 of argv) with title "OpenSSH" default answer "" with hidden answer buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel" with icon caution
		return text returned of response
	on error number -128
		error number 1
	end try
end run
APPLESCRIPT
		;;
esac
