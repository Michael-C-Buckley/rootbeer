function fcd --description 'Interactive directory change with fzf'
    set -l selected_path (fd . | fzf --height 40% --reverse)

    if test -n "$selected_path"
        if test -d "$selected_path"
            cd "$selected_path"
        else
            cd (dirname "$selected_path")
        end
    end
end
