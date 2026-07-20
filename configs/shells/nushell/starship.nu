let autoload_dir = ($nu.data-dir | path join "vendor/autoload")

$env.STARSHIP_CONFIG = "/home/michael/.config/starship/default.toml"
$env.TRANSIENT_PROMPT_COMMAND = {|| "" }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = "."

if not ($autoload_dir | path exists) {
    mkdir $autoload_dir
}

if (which starship | is-empty) {
    print -e "starship not found on PATH; skipping init"
} else {
    starship init nu | save -f ($autoload_dir | path join "starship.nu")
}
