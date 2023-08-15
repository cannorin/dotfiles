export FPATH=$FPATH:~/.local/share/zsh/functions/Completion
autoload -U compinit
compinit -u

export EDITOR=vim

# load global configurations
() {
  local -a conf_files=($HOME/.zshrc.d/*.{sh,zsh}(N))
  local rcfile
  # sort and source conf files
  for rcfile in ${(o)conf_files}; do
    # ignore files that begin with a tilde
    case ${rcfile:t} in '~'*) continue;; esac
    source "$rcfile"
  done
}

# load platform-specific configuration
() {
  local PLATFORM
  uname -a >/dev/null 2>&1
  case "$(uname -a)" in;
    *Microsoft*)
      PLATFORM="wsl"
      export WSL_VERSION=1
      ;;
    *microsoft*)
      PLATFORM="wsl"
      export WSL_VERSION=2
      ;;
    Linux*)   PLATFORM="linux";;
    Darwin*)  PLATFORM="osx";;
    CYGWIN*)  PLATFORM="cygwin";;
    MINGW*)   PLATFORM="msys";; 
    *Msys)    PLATFORM="msys"
  esac

  if [ -f "$HOME/.zshrc-platform.d/$PLATFORM.zsh" ]; then
    source "$HOME/.zshrc-platform.d/$PLATFORM.zsh"
  fi
}

export PATH=$HOME/.local.bin:$PATH:/usr/sbin:/usr/local/sbin
command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

setopt auto_pushd nolistbeep list_packed
setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys

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
    PROMPT="%B%/#%b "
2   PROMPT2="%_$ "
    SPROMPT="%B%r is correct? [n,y,a,e] : "
    ;;
*)
    PROMPT="%(5~|%-1~/.../%2~|%4~) $ "
    PROMPT2="%(5~|%-1~/.../%2~|%4~) # "
    SPROMPT="%r ? [nyae] : "
    ;;
  esac

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]; then
    RPROMPT="%{$fg_bold[white]%}[%M]"
  fi
}
 
prompt

command -v nvim &> /dev/null && alias vim="nvim"
alias ls="ls -G --color"
alias reload="source ~/.zshrc"
alias sudo-it='sudo -s -- sh -c "$(fc -nl | tail -n 1)"'

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $@;;
    *.tar.xz) tar Jxvf $@;;
    *.zip) unzip $@;;
    *.lzh) lha e $@;;
    *.tar.bz2|*.tbz) tar xjvf $@;;
    *.tar.Z) tar zxvf $@;;
    *.gz) gzip -d $@;;
    *.bz2) bzip2 -dc $@;;
    *.Z) uncompress $@;;
    *.tar) tar xvf $@;;
    *.arj) unarj $@;;
  esac
}

function c() {
  cmpargs=$(echo $@ | awk -F '--' '{$0=$1}1')
  runargs=$(echo $@ | awk -F '--' '{$0=$2}1')
  gcc -o a.out $cmpargs && {
    ./a.out $runargs
    rm a.out
  }
}
