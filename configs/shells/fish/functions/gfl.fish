# Select a commit with fzf and show it.
function gfl --description 'Select a commit with fzf and show it'
    command -q git; and command -q fzf; or begin
        echo 'gfl: git and fzf are required' >&2
        return 127
    end
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1

    set -l commit (command git log --format='%C(auto)%h%x09%s%d' | \
        command fzf --ansi --height 60% --reverse --border --delimiter '\t' \
            --with-nth '2..' --preview 'git show --color=always {1}' \
            --preview-window 'right:60%:wrap')
    test -n "$commit"; or return
    set -l hash (string replace -r '\t.*' '' -- "$commit")
    command git show "$hash"
end
