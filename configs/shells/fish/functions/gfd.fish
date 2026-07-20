# Select a changed file with fzf and view its unstaged diff.
function gfd --description 'Select a changed file with fzf and view its unstaged diff'
    command -q git; and command -q fzf; or begin
        echo 'gfd: git and fzf are required' >&2
        return 127
    end
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1

    set -l file (command git ls-files -m -d | \
        command fzf --height 60% --reverse --border \
            --preview 'git diff --color=always -- {}' \
            --preview-window 'right:60%:wrap')
    test -n "$file"; and command git diff -- "$file"
end
