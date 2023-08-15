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
   git fetch -p
   git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
}


