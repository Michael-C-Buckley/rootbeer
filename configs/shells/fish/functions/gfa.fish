# Select changed files with fzf and stage them.
function gfa --description 'Select changed files with fzf and stage them'
    command -q git; and command -q fzf; or begin
        echo 'gfa: git and fzf are required' >&2
        return 127
    end
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1

    set -l files (command git ls-files -m -d -o --exclude-standard | \
        command fzf --multi --height 60% --reverse --border \
            --preview 'git diff --color=always -- {}' \
            --preview-window 'right:60%:wrap')
    test -n "$files"; and command git add -A -- $files
end
