function _git_repo_name { 
    gittopdir=$(git rev-parse --git-dir 2> /dev/null)
    if [[ "foo$gittopdir" == "foo.git" ]]; then
        echo `basename $(pwd)`
    elif [[ "foo$gittopdir" != "foo" ]]; then
        echo `dirname $gittopdir | xargs basename`
    fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%F{163}(%F{057}$(_git_repo_name):%F{214}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{163})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{160}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{042}✔"

function custom_prompt {
  ((spare_width = ${COLUMNS}))
  prompt=" "

  # Git
  branch=$(git_current_branch)
  if [[ ${#branch} -eq 0 ]] then
    git_prompt=""
  else
    git_prompt="$(_git_repo_name):$branch"
    git_prompt_colored="%F{163}(%F{057}$(_git_repo_name)%F{111}:%F{214}$branch%F{163})"
  fi

  git_prompt_size=${#git_prompt}
  ((git_prompt_size=git_prompt_size+2))
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    git_c=" %F{160}X"
    ((git_prompt_size=git_prompt_size+2))
    git_prompt_colored="%F{163}(%F{057}$(_git_repo_name)%F{111}:%F{214}$branch%F%F{160}$git_c%F{163})"
  fi


  # path word: 
  cuspath="${PWD}"

  # Time
  custime="{HH:MM:SS}"

  path_size=${#cuspath}
  custime_size=${#custime}
  word_size=5

  (( spare_width = ${spare_width} - (${path_size} + ${git_prompt_size} + ${custime_size} + ${word_size}) ))
  while [ ${#prompt} -lt $spare_width ]; do
    prompt=" $prompt"
  done

  prompt="%F{092}┌─{%F{215}%*%F{092}}-[%F{051}$cuspath%F{092}]$prompt$git_prompt_colored"
  echo $prompt
}

setopt prompt_subst

PROMPT='
$(custom_prompt)
%F{092}└─> %F{reset}'
