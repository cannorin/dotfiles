export GPG_TTY=$(tty)

case $WSL_VERSION in;
  1)
    export DISPLAY=localhost:0.0
    ;;
  2)
    ;;
esac


unsetopt PATH_DIRS

