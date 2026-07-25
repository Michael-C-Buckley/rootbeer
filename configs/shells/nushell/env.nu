$env.NH_FLAKE = '/home/michael/.config/nixos'

# Starship
let autoload_dir = ($nu.data-dir | path join "vendor/autoload")

if ($env.STARSHIP_CONFIG? | is-empty) {
    $env.STARSHIP_CONFIG = "/home/michael/.config/starship/default.toml"
}


$env.TRANSIENT_PROMPT_COMMAND = {|| "" }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = "."

if not ($autoload_dir | path exists) {
    mkdir $autoload_dir
}

if (which starship | is-empty) {
    print -e "starship not found on PATH; skipping init"
} else {
    starship init nu | save -f ($autoload_dir | path join "starship.nu")
}



# ── Abbreviations ─────────────────────────────────────────────────────────────
# Fish-style abbreviations: they expand inline on space/enter, and the expanded
# form is what gets stored in history. Sourced from config.nu.
#
# NOTE: record values must be quoted strings, otherwise nushell parses the
# embedded spaces as additional record entries.

# Base abbreviations, always available
$env.config.abbreviations = {
    fg:     "job unfreeze"
    cl:     "clear"
    fenv:   "$env"                  # nu equivalent of fish's `set --show`
    nv:     "nvim"
    ll:     "ls -l"
    la:     "ls -a"
    k:      "kubectl"
    "..":   "cd .."
    "...":  "cd ../.."
    "....": "cd ../../.."
}

if (which eza | is-not-empty) {
    $env.config.abbreviations = ($env.config.abbreviations | merge {
        tree: "eza --tree --icons"
        lll:  "eza -lah --git --icons"
    })
}

if (which git | is-not-empty) {
    $env.config.abbreviations = ($env.config.abbreviations | merge {
        g:   "git"
        ga:  "git add"
        gaa: "git add ."
        gs:  "git status"
        gd:  "git diff"
        gds: "git diff --staged"
        gl:  "git log --oneline --graph --decorate"
        gp:  "git pull"
        gP:  "git push"
        gc:  "git commit"
        gcm: "git commit -m"
        gco: "git checkout"
        gb:  "git branch"
        gr:  "git remote"
        grv: "git remote -v"
    })
}

if (which tig | is-not-empty) {
    $env.config.abbreviations = ($env.config.abbreviations | merge {
        t:   "tig"
        ts:  "tig status"
        tf:  "tig --follow"
    })
}

# gitui shortcut, only when installed
if (which gitui | is-not-empty) {
    $env.config.abbreviations = ($env.config.abbreviations | merge {
        gu: "gitui"
    })
}
