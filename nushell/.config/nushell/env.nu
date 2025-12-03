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
    $env.PATH = ($env.PATH | prepend ($env.HOME | path join ".local/share/mise/shims"))
    mise activate nu | lines | where { |line| not ($line starts-with "set,") and not ($line starts-with "hide,") } | str join "\n" | save -f ~/.cache/mise.nu
}

# Zoxide
if (which zoxide | is-not-empty) {
    zoxide init nushell | save -f ~/.cache/zoxide.nu
}

# Carapace (completions)
if (which carapace | is-not-empty) {
    carapace _carapace nushell | save -f ~/.cache/carapace.nu
}

# Atuin (shell history)
if (which atuin | is-not-empty) {
    atuin init nu | save -f ~/.cache/atuin.nu
}
