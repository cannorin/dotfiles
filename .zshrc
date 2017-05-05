bindkey -v

export FPATH=$FPATH:~/.local/share/zsh/functions/Completion
autoload -U compinit
compinit

alias vim="nvim"

export EDITOR=vim
export PATH=$PATH:/usr/sbin:/usr/local/sbin:~/.local/bin:/usr/local/heroku/bin
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
export ANT_HOME=/usr/share/ant
export XDG_CONFIG_HOME=~/.config
eval `ssh-agent` > /dev/null
ssh-add .ssh/id_rsa* > /dev/null 2>&1

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
alias richvim="VIM_RICH_MODE=1 vim"

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
 
function prompt(){
   case ${UID} in
0)
    PROMPT="%B%{[0m%}%/%{[34m%}%{[0m%}#%{[0m%}%b "
    PROMPT2="%{[0m%}%_%{[34m%}%{[0m%}$%{[0m%} "
    SPROMPT="%B%{[0m%}%r is correct? [n,y,a,e] %{[34m%}%{[0m%}:%{[0m%}%b "
    ;;
*)
    PROMPT="%/ %{[34m%}%{[0m%}$%{[0m%} "
    PROMPT2="%_%{[34m%}%{[0m%}#%{[0m%}%b "
    RPROMPT="%{[36m%}[${USER}@${HOST}]%{[0m%}"
    SPROMPT="%{[0m%}%r ? [nyae] %{[34m%}%{[0m%}:%{[0m%} "
    ;;
  esac
}
 
prompt
 
