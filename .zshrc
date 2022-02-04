export FPATH=$FPATH:~/.local/share/zsh/functions/Completion
autoload -U compinit
compinit -u

if [ -x "$(command -v nvim)" ]; then alias vim="nvim"; fi

export EDITOR=vim

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/sbin:/usr/local/sbin:/usr/local/heroku/bin:$HOME/.cabal/bin
export PATH=$PATH:$HOME/.opam/4.06.0/bin
export PATH=$PATH:$HOME/.dotnet/tools
export PATH=$PATH:/Users/alice/Library/Developer/Xamarin/android-sdk-macosx/platform-tools
export PATH=$PATH:$HOME/scilab-6.0.2/bin

if [ -f "$HOME/.windows" ]; then {
  export GPG_TTY=$(tty)
  export DISPLAY=localhost:0.0
}
elif [ -f "$HOME/.osx" ]; then {
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
  PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
  PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
  PATH="/opt/local/bin:$PATH"

  MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
  MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"
  MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
  MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
  MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"

  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

  export PATH="/usr/local/opt/icu4c/bin:$PATH"
  export PATH="/usr/local/opt/icu4c/sbin:$PATH"
  
  export FrameworkPathOverride=/Library/Frameworks/Mono.framework/Versions/Current/lib/mono/4.7.1-api
}
else {
  export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
  export ANT_HOME=/usr/share/ant
  export XDG_CONFIG_HOME=~/.config

  export XMODIFIERS DEFAULT=@im=fcitx
  export GTK_IM_MODULE DEFAULT=fcitx
  export QT_IM_MODULE DEFAULT=fcitx

  export FrameworkPathOverride=/usr/lib/mono/4.7.1-api/
  export DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER=0
  alias -s exe=winexe
  alias -s msi="wine msiexec /i"
  alias -s inf="wine rundll32 setupapi,InstallHinfSection DefaultInstall 132"

  PATH="/home/alice/perl5/bin${PATH:+:${PATH}}"; export PATH;
  PERL5LIB="/home/alice/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
  PERL_LOCAL_LIB_ROOT="/home/alice/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
  PERL_MB_OPT="--install_base \"/home/alice/perl5\""; export PERL_MB_OPT;
  PERL_MM_OPT="INSTALL_BASE=/home/alice/perl5"; export PERL_MM_OPT;
}
fi

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Setup ssh-agent
if [ -f ~/.ssh-agent ]; then
    . ~/.ssh-agent >/dev/null
  fi
if [ -z "$SSH_AGENT_PID" ] || ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
    ssh-agent > ~/.ssh-agent
    . ~/.ssh-agent >/dev/null
fi
if [ -f "$HOME/.ssh/id_rsa" ]; then ssh-add ~/.ssh/id_rsa* > /dev/null 2>&1; fi

setopt auto_pushd nolistbeep list_packed
setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys

alias ls="ls -G"
alias ls="ls --color"

alias -s fsx=fsharpi
alias -s csx=csharp

alias reload="source ~/.zshrc"
alias sudo-it='sudo -s -- sh -c "$(fc -nl | tail -n 1)"'

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

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]; then
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

function git-set-author-github() {
  git config --local --add user.email "cannorin@users.noreply.github.com"
  git config --local --add user.name "cannorin"
}

function git-reset-author-github() {
  git-set-author-github
  git commit --amend --reset-author
}

function git-set-author() {
  git config --local --add user.email "cannorin@gmail.com"
  git config --local --add user.name "cannorin"
}

function git-reset-author() {
  git-set-author
  git commit --amend --reset-author
}

function git-set-author-github-company() {
  git config --local --add user.email "cannorin@peano-system.jp"
  git config --local --add user.name "cannorin"
}

function git-reset-author-github-company() {
  git-set-author-github-company
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
  cmpargs=$(echo $@ | awk -F '--' '{$0=$1}1')
  runargs=$(echo $@ | awk -F '--' '{$0=$2}1')
  gcc -o a.out $cmpargs && {
    ./a.out $runargs
    rm a.out
  }
}

test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
