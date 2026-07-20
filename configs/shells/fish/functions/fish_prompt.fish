# Native fish reimplementation of the prompt I have been using on Starship

function __native_prompt_git_prefix
    command -q git; or return 1

    set -l top (command git rev-parse --show-toplevel 2>/dev/null)
    test -n "$top"; or return 1

    set -l prefix (command git rev-parse --show-prefix 2>/dev/null)
    if test -n "$prefix"
        string trim --right --chars=/ -- "$prefix"
    else
        path basename -- "$top"
    end
end

function __native_prompt_dir
    set -l git_prefix (__native_prompt_git_prefix)
    if test -n "$git_prefix"
        printf '%s%s%s ' (set_color cyan) $git_prefix (set_color normal)
    else
        printf '%s%s%s ' (set_color cyan) (prompt_pwd -d 0) (set_color normal)
    end
end

function __native_prompt_hostname
    set -q SSH_CONNECTION; or set -q SSH_CLIENT; or return
    printf '%s%s:%s' (set_color 5faf5f) (prompt_hostname) (set_color normal)
end

function __native_prompt_git_branch
    command -q git; or return

    set -l branch (command git symbolic-ref --quiet --short HEAD 2>/dev/null)
    if test -z "$branch"
        set branch (command git rev-parse --short HEAD 2>/dev/null)
    end

    test -n "$branch"; or return
    printf '%sgit:(%s%s%s)%s' (set_color blue) (set_color red) $branch (set_color blue) (set_color normal)
end

function __native_prompt_git_status
    command -q git; or return

    set -l status_lines (command git status --porcelain=v2 --branch 2>/dev/null)
    test -n "$status_lines"; or return

    set -l dirty_lines (string match --invert '#*' -- $status_lines)
    set -l ahead 0
    set -l behind 0
    for line in $status_lines
        if string match --quiet '# branch.ab *' -- $line
            set -l parts (string split ' ' -- $line)
            set ahead (string replace + '' -- $parts[3])
            set behind (string replace - '' -- $parts[4])
        end
    end

    set -l has_stash
    command git rev-parse --verify --quiet refs/stash >/dev/null 2>/dev/null
    and set has_stash yes

    set -l pieces
    if test (count $dirty_lines) -gt 0
        set --append pieces (set_color brmagenta)'*'(set_color normal)
    end

    if test "$ahead" -gt 0
        set --append pieces (set_color cyan)"⇡$ahead"(set_color normal)
    end

    if test "$behind" -gt 0
        set --append pieces (set_color cyan)"⇣$behind"(set_color normal)
    end

    if test -n "$has_stash"
        set --append pieces (set_color cyan)'≡'(set_color normal)
    end

    test (count $pieces) -gt 0; or return
    printf '%s ' (string join ' ' -- $pieces)
end

function __native_prompt_cmd_duration
    set -l duration $argv[1]
    test -n "$duration"; or return
    test "$duration" -ge 2000; or return

    set -l seconds (math "floor($duration / 1000)")
    set -l minutes (math "floor($seconds / 60)")
    set -l remainder (math "$seconds % 60")

    if test "$minutes" -gt 0
        printf '%s%sm %ss%s ' (set_color yellow) $minutes $remainder (set_color normal)
    else
        printf '%s%ss%s ' (set_color yellow) $seconds (set_color normal)
    end
end

function __native_prompt_nix_shell
    set -q IN_NIX_SHELL; or return

    switch "$IN_NIX_SHELL"
        case pure
            printf '%s✱ %s' (set_color green) (set_color normal)
        case impure
            printf '%s✱ %s' (set_color yellow) (set_color normal)
        case '*'
            printf '%s✱ %s' (set_color red) (set_color normal)
    end
end

function __native_prompt_time
    printf '%s%s%s' (set_color brblack) (date '+%H:%M:%S') (set_color normal)
end

function __native_prompt_jobs
    set -l job_count (count (jobs -p))
    test "$job_count" -gt 0; or return

    if test "$job_count" -eq 1
        printf '%s✦%s ' (set_color --bold brblue) (set_color normal)
    else
        printf '%s✦%s%s ' (set_color --bold brblue) $job_count (set_color normal)
    end
end

function __native_prompt_python
    set -l env_name
    if set -q VIRTUAL_ENV
        set env_name (path basename -- "$VIRTUAL_ENV")
    else if set -q CONDA_DEFAULT_ENV
        set env_name $CONDA_DEFAULT_ENV
    end

    test -n "$env_name"; or return
    printf '%s%s%s ' (set_color brblack) $env_name (set_color normal)
end

function __native_prompt_battery
    for battery in /sys/class/power_supply/BAT*
        test -r "$battery/capacity"; or continue
        test -r "$battery/status"; or continue

        set -l capacity (string trim -- (cat "$battery/capacity"))
        set -l state (string trim -- (cat "$battery/status"))

        if test "$state" = Discharging; and test "$capacity" -le 10
            printf '%s%s%%%s ' (set_color red) $capacity (set_color normal)
            return
        end
    end
end

function __native_prompt_character
    set -l last_status $argv[1]
    set -l color green

    if test "$last_status" -ne 0
        set color red
    end

    if test "$fish_bind_mode" = default
        printf '%s❮%s ' (set_color --bold brblue) (set_color normal)
    else
        printf '%s❯%s ' (set_color --bold $color) (set_color normal)
    end
end

function __native_prompt_first_line
    set -l cmd_duration $argv[1]
    printf '%s%s%s%s%s' \
        (__native_prompt_hostname) \
        (__native_prompt_dir) \
        (__native_prompt_git_branch) \
        (__native_prompt_git_status) \
        (__native_prompt_cmd_duration $cmd_duration)
end

function __native_prompt_right
    printf '%s%s' (__native_prompt_nix_shell) (__native_prompt_time)
end

function __native_prompt_second_line
    set -l last_status $argv[1]
    printf '%s%s%s%s' \
        (__native_prompt_battery) \
        (__native_prompt_jobs) \
        (__native_prompt_python) \
        (__native_prompt_character $last_status)
end

function fish_prompt
    set -l last_status $status

    if contains -- --final-rendering $argv
        printf '%s' (__native_prompt_character $last_status)
        return
    end

    set -l cmd_duration 0
    set -q CMD_DURATION; and set cmd_duration $CMD_DURATION

    set -l left (__native_prompt_first_line $cmd_duration)
    set -l right (__native_prompt_right)

    set -l columns 80
    set -q COLUMNS; and set columns $COLUMNS

    set -l left_width (string length --visible -- "$left")
    set -l right_width (string length --visible -- "$right")
    set -l fill_width (math "$columns - $left_width - $right_width")
    test "$fill_width" -gt 1; or set fill_width 1

    printf '%s%s%s\n' $left (string repeat --count $fill_width ' ') $right
    printf '%s' (__native_prompt_second_line $last_status)
end
