# ── Prompt ───────────────────────────────────────────────────────────────────
# A custom native prompt based on the "default" starship that I use
# This version supports vi and emacs edit modes

def prompt_command_result [command: closure] {
    do $command | complete
}

def prompt_git_prefix [] {
    let top = (prompt_command_result { git rev-parse --show-toplevel })
    if $top.exit_code != 0 {
        return ""
    }

    let prefix = (prompt_command_result { git rev-parse --show-prefix })
    let prefix_text = if $prefix.exit_code == 0 { $prefix.stdout | str trim } else { "" }

    if $prefix_text != "" {
        $prefix_text | str trim --right --char "/"
    } else {
        $top.stdout | str trim | path basename
    }
}

def prompt_home_relative [path: string] {
    let home = ($env.HOME? | default "")

    if ($home != "" and ($path | str starts-with $home)) {
        $path | str replace $home "~"
    } else {
        $path
    }
}

def prompt_hostname [] {
    let has_ssh = (($env.SSH_CONNECTION? | default "") != "" or ($env.SSH_CLIENT? | default "") != "")
    if not $has_ssh {
        return ""
    }

    let host = (prompt_command_result { hostname })
    if $host.exit_code == 0 {
        $"(ansi -e '38;5;71m')($host.stdout | str trim):(ansi reset)"
    } else {
        ""
    }
}

def prompt_directory [] {
    let git_prefix = (prompt_git_prefix)
    let dir = if $git_prefix != "" {
        $git_prefix
    } else {
        prompt_home_relative $env.PWD
    }

    $"(ansi cyan)($dir)(ansi reset) "
}

def prompt_git_branch [] {
    let branch_result = (prompt_command_result { git symbolic-ref --quiet --short HEAD })
    let branch = if $branch_result.exit_code == 0 {
        $branch_result.stdout | str trim
    } else {
        let hash_result = (prompt_command_result { git rev-parse --short HEAD })
        if $hash_result.exit_code == 0 { $hash_result.stdout | str trim } else { "" }
    }

    if $branch == "" {
        ""
    } else {
        $"(ansi blue)git:\((ansi -e '38;5;1m')($branch)(ansi blue)\)(ansi reset)"
    }
}

def prompt_git_status [] {
    let status_result = (prompt_command_result { git status --porcelain=v2 --branch })
    if $status_result.exit_code != 0 {
        return ""
    }

    let status_lines = ($status_result.stdout | lines)
    let dirty_count = ($status_lines | where {|line| not ($line | str starts-with "#") } | length)
    let ab_line = ($status_lines | where {|line| $line | str starts-with "# branch.ab " } | get -o 0 | default "")
    let ab_parts = ($ab_line | split row " ")
    let ahead = ($ab_parts | get -o 2 | default "+0" | str replace "+" "" | into int)
    let behind = ($ab_parts | get -o 3 | default "-0" | str replace "-" "" | into int)
    let stash_result = (prompt_command_result { git rev-parse --verify --quiet refs/stash })

    let dirty = if $dirty_count > 0 { $"(ansi -e '38;5;218m')*(ansi cyan)" } else { "" }
    let ahead_text = if $ahead > 0 { $"⇡($ahead)" } else { "" }
    let behind_text = if $behind > 0 { $"⇣($behind)" } else { "" }
    let stash_text = if $stash_result.exit_code == 0 { "≡" } else { "" }
    let remote = $"($ahead_text)($behind_text)($stash_text)"

    if ($dirty == "" and $remote == "") {
        ""
    } else if $remote == "" {
        $"($dirty)(ansi reset) "
    } else {
        $"(ansi cyan)($dirty) ($remote)(ansi reset) "
    }
}

def prompt_cmd_duration [] {
    let duration = ($env.CMD_DURATION_MS? | default 0 | into int)
    if $duration < 2000 {
        return ""
    }

    let seconds = ($duration // 1000)
    let hours = ($seconds // 3600)
    let minutes = (($seconds mod 3600) // 60)
    let remainder = ($seconds mod 60)
    let text = if $hours > 0 {
        $"($hours)h($minutes)m($remainder)s"
    } else if $minutes > 0 {
        $"($minutes)m($remainder)s"
    } else {
        $"($seconds)s"
    }

    $"(ansi yellow)($text)(ansi reset) "
}

def prompt_nix_shell [] {
    let nix_shell = ($env.IN_NIX_SHELL? | default "")
    if $nix_shell == "" {
        return ""
    }

    let color = match $nix_shell {
        "pure" => "green"
        "impure" => "yellow"
        _ => "red"
    }

    $"(ansi $color)✱ (ansi reset)"
}

def prompt_time [] {
    let time = (date now | format date "%H:%M:%S")
    $"(ansi grey) ($time) (ansi reset)"
}

def prompt_jobs [] {
    let job_count = (job list | length)
    if $job_count == 0 {
        ""
    } else if $job_count == 1 {
        $"(ansi blue_bold)✦(ansi reset) "
    } else {
        $"(ansi blue_bold)✦($job_count)(ansi reset) "
    }
}

def prompt_python [] {
    let virtualenv = ($env.VIRTUAL_ENV? | default "")
    let conda = ($env.CONDA_DEFAULT_ENV? | default "")
    let env_name = if $virtualenv != "" {
        $virtualenv | path basename
    } else {
        $conda
    }

    if $env_name == "" {
        ""
    } else {
        $"(ansi dark_gray)($env_name)(ansi reset) "
    }
}

def prompt_battery [] {
    for battery in (glob "/sys/class/power_supply/BAT*") {
        let capacity_path = ($battery | path join "capacity")
        let status_path = ($battery | path join "status")

        if (($capacity_path | path exists) and ($status_path | path exists)) {
            let capacity = (open $capacity_path | str trim | into int)
            let state = (open $status_path | str trim)

            if ($state == "Discharging" and $capacity <= 10) {
                return $"(ansi red)($capacity)%(ansi reset) "
            }
        }
    }

    ""
}

def prompt_second_line [] {
    $"(prompt_battery)(prompt_jobs)(prompt_python)"
}

def create_left_prompt [] {
    $"(prompt_hostname)(prompt_directory)(prompt_git_branch)(prompt_git_status)(prompt_cmd_duration)\n(prompt_second_line)"
}

def create_right_prompt [] {
    $"(prompt_nix_shell)(prompt_time)"
}

def create_prompt_character [] {
    let last_exit_code = ($env.LAST_EXIT_CODE? | default 0 | into int)
    let color = if $last_exit_code == 0 { ansi green_bold } else { ansi red_bold }
    $"($color)❯(ansi reset) "
}

$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }
$env.PROMPT_INDICATOR = { create_prompt_character }
$env.PROMPT_INDICATOR_VI_INSERT = { create_prompt_character }
$env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi yellow_bold)● (ansi reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"|| "

$env.TRANSIENT_PROMPT_COMMAND = {|| "" }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""
