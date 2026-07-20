function __ssh_config_hosts --description 'List concrete hosts from SSH config files'
    set -l config_files $HOME/.ssh/config

    if test -d $HOME/.ssh/config.d
        set -a config_files $HOME/.ssh/config.d/*.conf
    end

    if test -r $HOME/.orbstack/ssh/config
        set -a config_files $HOME/.orbstack/ssh/config
    end

    awk '
        tolower($1) == "host" {
            for (i = 2; i <= NF; i++) {
                if ($i ~ /^#/) break
                if ($i !~ /[*!?]/) print $i
            }
        }
    ' $config_files 2>/dev/null | sort -fu
end

function sshf --description 'Choose an SSH host with fzf' --wraps ssh
    if not type -q fzf
        echo 'sshf: fzf is not installed' >&2
        return 127
    end

    set -l host (__ssh_config_hosts | fzf --height 40% --reverse --prompt 'ssh> ')
    test -n "$host"; or return

    command ssh $argv "$host"
end
