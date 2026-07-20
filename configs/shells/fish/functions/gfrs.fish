# Select staged files with fzf and restore them from the staging area.
function gfrs --description 'Select staged files with fzf and unstage them'
    command -q git; and command -q fzf; or begin
        echo 'gfrs: git and fzf are required' >&2
        return 127
    end
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1

    set -l files (command git diff --cached --name-only | \
        command fzf --multi --height 60% --reverse --border \
            --preview 'git diff --cached --color=always -- {}' \
            --preview-window 'right:60%:wrap')
    test -n "$files"; and command git restore --staged -- $files
end
