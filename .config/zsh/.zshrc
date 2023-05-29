# Tmux
if [ -z "$TMUX" ] && [ "$(tty)" != "/dev/tty*" ]; then
  #exec tmux
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History in cache directory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# aliases and functions
[ -f "${XDG_CONFIG_HOME}/shell/rc" ] && source "${XDG_CONFIG_HOME}/shell/rc"
[ -f "${XDG_CONFIG_HOME}/shell/functions" ] && source "${XDG_CONFIG_HOME}/shell/functions"
[ -f "${XDG_CONFIG_HOME}/shell/aliases" ] && source "${XDG_CONFIG_HOME}/shell/aliases"

# options
unsetopt menu_complete
unsetopt flowcontrol
setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt interactivecomments
setopt auto_cd
# setopt correct

autoload -Uz compinit && compinit

# Case-insensitive path completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Enable git relative paths completion: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitfast
fpath=(~/.config/zsh/gitfast $fpath)
source ~/.config/zsh/gitfast/git-prompt.sh

# disable vim mode
# bindkey -e

# initialize stuff
eval $(thefuck --alias)
eval "$(zoxide init zsh)"


# plugins
source $XDG_CONFIG_HOME/zsh/catppuccin-zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
#source /usr/share/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh



# lfcd
lfcd () {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        command rm -f "$tmp" # command is needed in case rm is verbose via aliases
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

bindkey -s '^o' 'lfcd\n'


zstyle ':completion:*' menu select

# history substring search options
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# ctrl+backspace/delete
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# home/end/delete
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# ctrl+left/right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# fix ctrl+l tmux
if [ ! -z "$TMUX" ]; then
  clear-scrollback-and-screen () {
    zle clear-screen
    tmux clear-history
  }

  zle -N clear-scrollback-and-screen
  bindkey -v '^L' clear-scrollback-and-screen
fi



# powerlevel10k

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

