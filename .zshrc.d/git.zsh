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

function git-prune-branches() {
  local remotes main_ref main_branch candidate merged branch worktree
  local -a branches=()

  remotes=$(git remote) || return
  if [[ -n $remotes ]]; then
    git fetch -p || return
  fi

  main_ref=$(git symbolic-ref -q refs/remotes/origin/HEAD) || main_ref=
  for candidate in "$main_ref" refs/remotes/origin/main refs/remotes/origin/master refs/heads/main refs/heads/master; do
    if [[ -n $candidate ]] && git show-ref --verify --quiet "$candidate"; then
      main_ref=$candidate
      break
    fi
    main_ref=
  done
  if [[ -z $main_ref ]]; then
    print -u2 'git-prune-branches: main branch not found (origin/HEAD, main or master)'
    return 1
  fi
  main_branch=${main_ref#refs/remotes/origin/}
  main_branch=${main_branch#refs/heads/}

  merged=$(git for-each-ref --merged="$main_ref" --format='%(refname)%09%(worktreepath)' refs/heads/) || return
  while IFS=$'\t' read -r branch worktree; do
    branch=${branch#refs/heads/}
    [[ -z $branch || $branch == $main_branch || -n $worktree ]] && continue
    branches+=("$branch")
  done <<< "$merged"

  if (( ${#branches} )); then
    # Already checked against main; -d would check each branch's upstream instead.
    git branch -D -- "${branches[@]}"
  fi
}


