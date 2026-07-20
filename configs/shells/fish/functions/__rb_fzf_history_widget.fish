function __rb_fzf_history_widget --description 'Search command history with fzf'
    command -q fzf; or return

    history merge
    set -l selection (history | command fzf --height 60% --reverse --border \
        --query (commandline) --prompt 'history> ')
    test -n "$selection"; and commandline -- "$selection"
    commandline -f repaint
end
