bindkey -v
 
autoload -U compinit
compinit 
EDITOR=vim

export PATH=$PATH:/usr/sbin:/usr/local/sbin:~/.local/bin

autoload -U tetris
zle -N tetris
bindkey '^T' tetris

setopt auto_pushd nolistbeep list_packed
setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys

alias ls="ls -G"
alias ls="ls --color"

HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups
setopt share_history 
 
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
 
powerline-daemon -q
. ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
