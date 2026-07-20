const config_dir = ($nu.config-path | path dirname)
source ($config_dir | path join "git.nu")
