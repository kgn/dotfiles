# Nushell Config for Omarchy

# ===== Settings =====
$env.config = {
    show_banner: false
    edit_mode: emacs

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }

    history: {
        max_size: 10000
        sync_on_enter: true
        file_format: "sqlite"
    }

    cursor_shape: {
        emacs: line
        vi_insert: line
        vi_normal: block
    }

    table: {
        mode: rounded
        index_mode: auto
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
    }

    hooks: {
        env_change: {
            PWD: [{ ||
                if (which direnv | is-not-empty) {
                    direnv export json | from json | default {} | load-env
                }
            }]
        }
    }
}

# ===== Aliases =====

# File system (using eza)
alias ls = eza -lh --group-directories-first --icons=auto
alias lsa = eza -lah --group-directories-first --icons=auto
alias lt = eza --tree --level=2 --long --icons --git
alias lta = eza --tree --level=2 --long --icons --git -a

# Fuzzy finder
alias ff = fzf --preview 'bat --style=numbers --color=always {}'

# Directories
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..

# Tools
alias d = docker
alias g = git
alias gcm = git commit -m
alias gcam = git commit -a -m
alias gcad = git commit -a --amend

# Neovim
def n [...args] {
    if ($args | is-empty) {
        nvim .
    } else {
        nvim ...$args
    }
}

# Open files with default application
def open [...args] {
    xdg-open ...$args out+err> /dev/null &
}

# ===== Integrations =====

# Zoxide (smart cd)
if (which zoxide | is-not-empty) {
    source ~/.cache/zoxide.nu
}

# Mise (version manager)
if (which mise | is-not-empty) {
    source ~/.cache/mise.nu
}

# Carapace (completions)
if (which carapace | is-not-empty) {
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
    source ~/.cache/carapace.nu
}

# Atuin (shell history)
if (which atuin | is-not-empty) {
    source ~/.cache/atuin.nu
}
