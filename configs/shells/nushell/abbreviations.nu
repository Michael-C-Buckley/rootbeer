# ── Abbreviations ─────────────────────────────────────────────────────────────
# Fish-style abbreviations: they expand inline on space/enter, and the expanded
# form is what gets stored in history. Sourced from config.nu.
#
# NOTE: record values must be quoted strings, otherwise nushell parses the
# embedded spaces as additional record entries.

# Base abbreviations, always available
$env.config.abbreviations = {
    reload: "exec nu"               # restart nu to reload config
    cl:     "clear"
    fenv:   "$env"                  # nu equivalent of fish's `set --show`
    nv:     "nvim"
    ll:     "ls -l"
    la:     "ls -a"
    "..":   "cd .."
    "...":  "cd ../.."
    "....": "cd ../../.."
}

# Prettier tree listing when eza is installed
if (which eza | is-not-empty) {
    $env.config.abbreviations = ($env.config.abbreviations | merge {
        tree: "eza --tree --icons"
    })
}

# Git abbreviations, only when the git binary is available
if (which git | is-not-empty) {
    $env.config.abbreviations = ($env.config.abbreviations | merge {
        g:   "git"
        ga:  "git add"
        gaa: "git add ."
        gs:  "git status"
        gd:  "git diff"
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

# gitui shortcut, only when installed
if (which gitui | is-not-empty) {
    $env.config.abbreviations = ($env.config.abbreviations | merge {
        gu: "gitui"
    })
}
