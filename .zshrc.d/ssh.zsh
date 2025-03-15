if [ -f ~/.ssh-agent ]; then
  . ~/.ssh-agent >/dev/null
fi
if [ -z "$SSH_AGENT_PID" ] || ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
  ssh-agent > ~/.ssh-agent
  . ~/.ssh-agent >/dev/null
fi
for ID_FILE in $HOME/.ssh/id_*; do
  if [ -f "$ID_FILE" ]; then ssh-add $ID_FILE >/dev/null 2>&1; fi
done

