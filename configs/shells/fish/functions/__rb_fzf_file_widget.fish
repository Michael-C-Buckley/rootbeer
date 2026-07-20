function __rb_fzf_file_widget --description 'Insert a file selected with fzf'
    command -q fd; and command -q fzf; or return

    set -l file (command fd --type f --hidden --follow --exclude .git . | \
        command fzf --height 60% --reverse --border --prompt 'file> ' \
            --preview 'bat --color=always --style=numbers --line-range=:500 -- {} 2>/dev/null' \
            --preview-window 'right:60%:wrap')
    test -n "$file"; and commandline -rt -- (string escape -- "$file")
    commandline -f repaint
end
