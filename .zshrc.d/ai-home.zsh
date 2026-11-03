_nearest_ai_home() {
  local marker=$1 fallback=$2 dir=${PWD:A} home=${HOME:A} repo_root

  if [[ "$dir/" == "$home/"* ]]; then
    repo_root=$(command git -C "$dir" rev-parse --show-toplevel 2>/dev/null)
    # Account homes live above projects so a repository cannot supply one.
    if [[ -n $repo_root ]]; then
      repo_root=${repo_root:A}
      [[ $repo_root != $home ]] && dir=${repo_root:h}
    fi

    while true; do
      if [[ -d "$dir/$marker" ]]; then
        print -r -- "$dir/$marker"
        return
      fi
      [[ $dir == $home ]] && break
      dir=${dir:h}
    done
  fi

  print -r -- "$fallback"
}

codex() {
  local config_home=$(_nearest_ai_home .codex-home "$HOME/.codex")
  CODEX_HOME=$config_home command codex "$@"
}

claude() {
  local config_home=$(_nearest_ai_home .claude-home "$HOME/.claude")
  CLAUDE_CONFIG_DIR=$config_home command claude "$@"
}
