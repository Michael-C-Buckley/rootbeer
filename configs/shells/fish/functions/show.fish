function show --description 'Show VTY command output'
    sudo vtysh -c (string join ' ' -- show $argv)
end
