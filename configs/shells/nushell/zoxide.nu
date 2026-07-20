# Zoxide integration with a dependency-free fallback for `z`.

export-env {
    $env.config = (
        $env.config?
        | default {}
        | upsert hooks { default {} }
        | upsert hooks.env_change { default {} }
        | upsert hooks.env_change.PWD { default [] }
    )

    let already_hooked = (
        $env.config.hooks.env_change.PWD
        | any { try { get rootbeer_zoxide_hook } catch { false } }
    )

    if not $already_hooked {
        $env.config.hooks.env_change.PWD ++= [{
            rootbeer_zoxide_hook: true
            code: {|_, directory|
                if (which zoxide | is-not-empty) {
                    ^zoxide add -- $directory
                }
            }
        }]
    }
}

def --env --wrapped __zoxide_z [...rest: string] {
    let destination = match $rest {
        [] => { "~" }
        ["-"] => { "-" }
        [$directory] if ($directory | path expand | path type) == "dir" => { $directory }
        _ if (which zoxide | is-not-empty) => {
            ^zoxide query --exclude $env.PWD -- ...$rest | str trim --right --char (char newline)
        }
        _ => {
            error make { msg: "z: zoxide is not installed and the target is not a directory" }
        }
    }

    cd $destination
}

def --env --wrapped __zoxide_zi [...rest: string] {
    if (which zoxide | is-empty) {
        error make { msg: "zi: zoxide is not installed" }
    }

    let destination = (
        ^zoxide query --interactive -- ...$rest
        | str trim --right --char (char newline)
    )
    cd $destination
}

# Standard zoxide commands: smart cd and interactive smart cd.
alias z = __zoxide_z
alias zi = __zoxide_zi
