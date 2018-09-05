bindkey -v

export FPATH=$FPATH:~/.local/share/zsh/functions/Completion
autoload -U compinit
compinit -u

alias vim="nvim"

export EDITOR=vim
export PATH=$PATH:/usr/sbin:/usr/local/sbin:~/.local/bin:/usr/local/heroku/bin:~/.cabal/bin
export PATH=$PATH:~/.opam/4.06.0/bin
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
export ANT_HOME=/usr/share/ant
export XDG_CONFIG_HOME=~/.config
eval `ssh-agent` > /dev/null
ssh-add ~/.ssh/id_rsa* > /dev/null 2>&1

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

alias -s fsx=fsharpi
alias -s csx=csharp

alias reload="source ~/.zshrc"
alias sudoit='sudo -s -- sh -c "$(fc -nl | tail -n 1)"'

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
    PROMPT2="%_$ "
    SPROMPT="%B%r is correct? [n,y,a,e] : "
    ;;
*)
    PROMPT="%(5~|%-1~/.../%2~|%4~) $ "
    PROMPT2="%(5~|%-1~/.../%2~|%4~) # "
    SPROMPT="%r ? [nyae] : "
    ;;
  esac

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_CONNECTION"] || [ -n "$SSH_TTY" ]; then
    RPROMPT="%{$fg_bold[white]%}[%M]"
  fi
}
 
prompt

#function fsc () { unbuffer fsharpc --consolecolors+ $@ |& sed -u "s/.\[\?1h.=.\[6n.\[H.\[J//g" | less -r }

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

function google() {
  query=$(echo "$@" | sed 's/\s/%20/g')
  lynx "https://google.co.jp/search?q=$query"
}

function winexe() {
  [ $# -eq 0 ] &&
  {
    echo "Usage: exehandler filename"
    return 0
  }
  [ -f $1 ] ||
  {
    echo winexe: $1 not found
    return -1
  }

  EXEPATH="$(realpath $1)"
  checkdn="
  try
  {
      System.Reflection.AssemblyName.GetAssemblyName(\"$EXEPATH\");
      Environment.Exit(0);
  }
  catch(Exception e)
  {
      Environment.Exit(1);
  }"
  
  echo $checkdn | csharp >/dev/null 2>&1
  if [ $? -ne 0 ]; then
      shift;
      wine $EXEPATH $*
  else
      shift;
      mono $EXEPATH $*
  fi
}

function git-reset-author() {
  git config --local --add user.email "cannorin@users.noreply.github.com"
  git config --local --add user.name "cannorin"
  git commit --amend --reset-author
}

alias git-commit-today='git commit -m "$(LANG=C date)"'

function git-unignore() {
  [ -f ".gitignore" ] ||
  {
    echo git-unignore: .gitignore not found
    return -1
  }
  for file in $@; do
    echo !$file >> .gitignore
  done
}

function c() {
  gcc -o a.out $@ && {
    ./a.out
    rm a.out
  }
}

#[ -f "$HOME/codes/misc/FsxTools.dll" ] && alias fsharpi="fsharpi -r $HOME/codes/misc/FsxTools.dll"

if [ -f ".$HOME/windows" ]; then {
  export DISPLAY=localhost:0.0
  (
      command_path="/mnt/c/Program Files/VcXsrv/vcxsrv.exe"
      command_name=$(basename "$command_path")

      if ! tasklist.exe 2> /dev/null | fgrep -q "$command_name"; then
          "$command_path" :0 -multiwindow -xkbmodel jp106 -xkblayout jp -clipboard -noprimary -wgl > /dev/null 2>&1 &
      fi
  )
}
else {
  export FrameworkPathOverride=/usr/lib/mono/4.5/
  alias -s exe=winexe
  alias -s msi="wine msiexec /i"
  alias -s inf="wine rundll32 setupapi,InstallHinfSection DefaultInstall 132"
}
fi
