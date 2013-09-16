git_branch() {
  echo -ne $(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  STATUS=$(git status -s 2> /dev/null | tail -n 1)
  if [[ -n ${STATUS} ]]
  then
    echo "%{$fg[green]%}!%{$reset_color%}"
  else
    echo ""
  fi
}

git_prompt_info () {
  BRANCH=$(git_branch)
  if [[ ${BRANCH} != "" ]]
  then
    echo "%{$fg[green]%}${BRANCH}$(git_dirty)$(need_push)%{$reset_color%} "
  fi
}

need_push () {
  UNPUSHED=$(git cherry -v origin/$(git_branch) 2>/dev/null)
  if [[ -n ${UNPUSHED} ]]
  then
    echo "%{$fg[green]%}›%{$reset_color%}"
  fi
}

precmd () {
  PROMPT="%{$fg[blue]%}%m:%{$reset_color%} %{$fg[yellow]%}%~ %{$reset_color%}%{$fg[cyan]%}% %{$reset_color%}$(git_prompt_info)$ "
}
