git_branch() {
  echo -ne $(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  STATUS=$(git status -s 2> /dev/null | wc -l)
  if [[ ${STATUS} -eq 0 ]]
  then
    echo "green"
  else
    echo "red"
  fi
}

git_prompt_info () {
  BRANCH=$(git_branch)
  if [[ ${BRANCH} != "" ]]
  then
    echo "%{$fg[$(git_dirty)]%}${BRANCH}$(need_push)%{$reset_color%} "
  fi
}

need_push () {
  UNPUSHED=$(git cherry -v origin/$(git_branch) 2>/dev/null | wc -l)
  if [[ ${UNPUSHED} -gt 0 ]]
  then
    if [[ ${UNPUSHED} -gt 3 ]]
    then
      echo " ${UNPUSHED}›"
    else
      echo "$(repeat ${UNPUSHED} printf "›";print)"
    fi
  fi
}

precmd () {
  PROMPT="%{$fg[blue]%}%m%{$reset_color%} %{$fg[yellow]%}%~ %{$reset_color%}$(git_prompt_info)%{$fg[yellow]%}$%{$reset_color%} "
}
