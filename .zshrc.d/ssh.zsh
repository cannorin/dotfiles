if [ -f ~/.ssh-agent ]; then
    . ~/.ssh-agent >/dev/null
  fi
if [ -z "$SSH_AGENT_PID" ] || ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
    ssh-agent > ~/.ssh-agent
    . ~/.ssh-agent >/dev/null
fi
if [ -f "$HOME/.ssh/id_rsa" ]; then ssh-add ~/.ssh/id_rsa* > /dev/null 2>&1; fi


