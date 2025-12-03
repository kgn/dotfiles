# Nushell Environment Config for Omarchy

# Editor
$env.EDITOR = "nvim"
$env.SUDO_EDITOR = $env.EDITOR
$env.BAT_THEME = "ansi"

# XDG paths
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local/share")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")

# Path
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    ($env.HOME | path join ".local/bin")
    ($env.HOME | path join ".cargo/bin")
    "/usr/local/bin"
])

# Starship prompt
$env.STARSHIP_SHELL = "nu"
def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# Mise (polyglot version manager)
if (which mise | is-not-empty) {
    $env.MISE_SHELL = "nu"
    let mise_path = (which mise | get path.0)
    $env.PATH = ($env.PATH | prepend ($env.HOME | path join ".local/share/mise/shims"))
}

# Zoxide
if (which zoxide | is-not-empty) {
    zoxide init nushell | save -f ~/.cache/zoxide.nu
}
