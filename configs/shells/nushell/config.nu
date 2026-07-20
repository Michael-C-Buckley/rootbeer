const config_dir = ($nu.config-path | path dirname)

def xdg-config [] {
    $env.XDG_CONFIG_HOME? | default ($env.HOME | path join ".config")
}

def xdg-data [] {
    $env.XDG_DATA_HOME? | default ($env.HOME | path join ".local/share")
}

def xdg-cache [] {
    $env.XDG_CACHE_HOME? | default ($env.HOME | path join ".cache")
}

# ── Environment ──────────────────────────────────────────────────────────────

$env.config = {
    show_banner: false

    buffer_editor: "hx"

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: true
    }

    table: {
        mode: heavy
        index_mode: always
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 50
        }
    }

    cursor_shape: {
        emacs: line
        vi_insert: line
        vi_normal: block
    }

    #color_config.shape_external: { fg: "yellow" attr: "b" }

    edit_mode: emacs

    shell_integration: {
        osc2: true              # set terminal title
        osc7: true              # notify terminal of cwd
        osc9_9: false
        osc133: true            # shell prompt markers (for terminal apps)
        osc633: true
        reset_application_mode: true
    }

    render_right_prompt_on_last_line: false

    hooks: {
        pre_prompt: [{ null }]
        pre_execution: [{ null }]
    }

    keybindings: [
        {
            # currently kitty sends this for backspace, but h also works and is agreeable
            name: backspace_kill_word
            modifier: control
            keycode: char_h
            mode: [emacs, vi_insert, vi_normal]
            event: { edit: backspaceword }
        }
    ]
}

# ── Abbreviations ─────────────────────────────────────────────────────────────
source-env ($config_dir | path join "abbreviations.nu")
source ($config_dir | path join "zoxide.nu")

# ── SSH  ─────────────────────────────────────────────────────────────────────
if $nu.os-info.name == "macos" {
    # nix-darwin owns a nixpkgs OpenSSH agent here; Apple's agent lacks
    # libfido2 support for OpenSSH security-key identities.
    $env.SSH_AUTH_SOCK = ($env.HOME | path join ".ssh/agent/nix-fido.sock")
} else {
    let standard_agent = ($env.HOME | path join ".ssh/agent/internal.sock")

    if ($standard_agent | path exists) and (($standard_agent | path type) == "symlink" or ($standard_agent | path type) == "file") {
        $env.SSH_AUTH_SOCK = $standard_agent
    }
}

# ── Useful Custom Commands ────────────────────────────────────────────────────

# Find files by name
def ff [pattern: string] {
    ls **/*
    | where name =~ $pattern
}

# Quick HTTP GET and pretty-print JSON
def jget [url: string] {
    http get $url | to json | print
}

# Grep-like search in structured data
def contains [col: string, val: string] {
    where ($col | str contains $val)
}

# Show PATH as a list (much more readable)
def show-path [] {
    $env.PATH | each { |p| print $p }
}

# Process search shorthand
def pg [pattern: string] {
    ps | where name =~ $pattern
}

# Find a file or directory and cd to it
def --env fcd [] {
    let selection = (fd | fzf --height 40% --reverse)
    if $selection != "" {
        cd ($selection | path expand | path dirname)
    }
}

# List concrete aliases from the main SSH config and config.d snippets.
def ssh-config-hosts [] {
    let config_files = (
        [($env.HOME | path join ".ssh/config")]
        | append (glob ($env.HOME | path join ".ssh/config.d/*.conf"))
        | append (glob ($env.HOME | path join ".orbstack/ssh/config"))
    )

    $config_files
    | where { |file| $file | path exists }
    | each { |file| open --raw $file | lines }
    | flatten
    | where { |line| $line =~ "(?i)^\\s*Host\\s+" }
    | each { |line|
        $line
        | str replace --regex "(?i)^\\s*Host\\s+" ""
        | str replace --regex "\\s+#.*$" ""
        | split row --regex "\\s+"
      }
    | flatten
    | where { |host| $host !~ "[*!?]" }
    | uniq
    | sort
}

# Pick a configured SSH host with fzf. Arguments are passed as SSH options.
def --wrapped sshf [...args: string] {
    if (which fzf | is-empty) {
        error make { msg: "sshf: fzf is not installed" }
    }

    let host = (
        ssh-config-hosts
        | str join (char nl)
        | ^fzf --height 40% --reverse --prompt "ssh> "
        | str trim
    )

    if $host != "" {
        ^ssh ...$args $host
    }
}

# Function to wrap the default vim command and use nvim if available
def vim [...args] {
  if (which nvim | is-not-empty) {
    ^nvim ...$args
  } else if (which hx | is-not-empty) {
    ^hx ...$args
  } else if (which vim | is-not-empty) {
    ^vim ...$args
  } else {
    ^vi ...$args
  }
}


# ── Direnv ──────────────────────────────────────────────────────────────────────

use std/config *

# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) {
    # If direnv isn't installed, do nothing
    return
  }

  direnv export json | from json | default {} | load-env
  # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]

# ── Extra ──────────────────────────────────────────────────────────────────────
# Sudo shim that is universally compatible across my systems with no dependency on state
def sudo [...args] {
  if (which ^sudo | is-not-empty) {
    ^sudo ...$args
  } else if  (which ^doas | is-not-empty ) {
    doas ...$args
  } else {
    echo "nushell: sudo and doas not found"
  }
}

# Use rootbeer's bundled rb binary if it isn't already on PATH
def --wrapped rb [...args] {
  let local_rb = ($env.HOME | path join ".rootbeer/bin/rb")
  if (which ^rb | is-not-empty) {
    ^rb ...$args
  } else if ($local_rb | path exists) {
    ^$local_rb ...$args
  } else {
    echo "nushell: rb not found"
  }
}

# ── Completions ────────────────────────────────────────────────────────────────

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans | from json
}

# File-path completer as a fallback for when carapace returns nothing
let file_completer = {|spans: list<string>|
    let prefix = $spans | last
    ls ($prefix ++ "*")
    | each { |entry|
        let is_dir = ($entry.type == "dir")
        {
            value: (if $is_dir { $entry.name ++ "/" } else { $entry.name })
            description: $entry.type
        }
    }
    | sort-by value
}

# SSH host aliases are not provided by carapace, so complete them directly.
let ssh_completer = {|spans: list<string>|
    let command = ($spans | first | path basename)
    let current = ($spans | last)

    if $command == "ssh" and not ($current | str starts-with "-") {
        ssh-config-hosts
        | each { |host| { value: $host, description: "SSH host" } }
    } else {
        []
    }
}

# Multi-completer: handles SSH hosts, then tries carapace and file completion.
let multi_completer = {|spans: list<string>|
    let ssh_result = do $ssh_completer $spans
    if ($ssh_result | is-not-empty) {
        $ssh_result
    } else {
        let carapace_result = do $carapace_completer $spans
        if ($carapace_result | is-not-empty) {
            $carapace_result
        } else {
            do $file_completer $spans
        }
    }
}

$env.config.completions.external.completer = $multi_completer

#source-env ($config_dir | path join "prompt.nu")
source-env ($config_dir | path join "starship.nu")
