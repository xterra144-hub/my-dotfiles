#check
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================
# Oh My Zsh
# ============================================
export ZSH="$HOME/.oh-my-zsh"

# Тема
ZSH_THEME="powerlevel10k/powerlevel10k"
# Можно заменить на:
# ZSH_THEME="agnoster"
# ZSH_THEME="bira"

# Плагины
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
)

source $ZSH/oh-my-zsh.sh

# ============================================
# История
# ============================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt AUTO_CD
setopt CORRECT

# Дополнительно
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# ============================================
# Автодополнение
# ============================================
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Красивый список
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ============================================
# FZF
# ============================================

# Если установлен через пакетный менеджер
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# Если установлен через git
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ============================================
# Алиасы
# ============================================

alias ll='eza -alh --group-directories-first --icons'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c='clear'
# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gp='git pull'
alias gps='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Cargo
alias cr='cargo run'
alias cb='cargo build'
alias ct='cargo test'
alias cc='cargo check'
alias cf='cargo fmt'
alias cl='cargo clippy'

# Neovim
alias v='nvim'
alias vim='nvim'

# ============================================
# Функции
# ============================================

mkcd() {
    mkdir -p "$1" && cd "$1"
}

update-zsh() {
    omz update
}

update-plugins() {
    local custom=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

    for dir in "$custom"/plugins/*; do
        [[ -d "$dir/.git" ]] || continue
        echo "Updating $(basename "$dir")..."
        git -C "$dir" pull
    done
}
unalias ls 2>/dev/null
ls() {
    if [[ "$1" == "-e" || "$1" == "--english" ]]; then
        shift
        command eza --color=always --group-directories-first --icons "$@"
        echo ""
        echo "── Права доступа ──"
        for f in "${@:-.}"; do
            for file in "$f"/*(N) "$f"(N); do
                [[ -e "$file" ]] || continue
                local perms=$(stat -c '%A' "$file")
                local owner="${perms:1:3}"
                local group="${perms:4:3}"
                local others="${perms:7:3}"
                local name=$(basename "$file")

                translate() {
                    local p="$1"
                    local result=()
                    [[ ${p:0:1} == "r" ]] && result+=("read")
                    [[ ${p:1:1} == "w" ]] && result+=("write")
                    [[ ${p:2:1} == "x" ]] && result+=("execute")
                    [[ ${#result[@]} -eq 0 ]] && echo "none" || echo "${(j:, :)result}"
                }

                echo "$name:"
                echo "  Owner:  $(translate "$owner")"
                echo "  Group:  $(translate "$group")"
                echo "  Others: $(translate "$others")"
            done
        done
    else
        command  eza --tree --level=2 --color=always --icons"$@"
    fi
}

# ============================================
# PATH
# ============================================

export EDITOR=nvim
export VISUAL=nvim

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
#Snap
export PATH="/snap/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(zoxide init zsh)"
export PATH="$HOME/.local/bin:$PATH"
alias cat='bat --paging=never'
alias cat='bat --paging=never --color=always'
export PATH="$HOME/vcpkg:$PATH"
