WHITE="255;255;255"
BLACK="0;0;0"
BLUE="22;62;103"
YELLOW="110;80;0"
GREEN="40;127;119"

RESET="\e[0m"
FG_RGB="\e[38;2;"
BG_RGB="\e[48;2;"

SEPARATOR_RIGHT=""
SEPARATOR_LEFT=""

FOLDER_ICON=$'\uf115'
BRANCH_ICON=$'\uf418'
CLOCK_ICON=$'\uf43a'
GITHUB_ICON=$'\ue709'
GITLAB_ICON=$'\ue7eb'
BITBUCKET_ICON=$'\uf171'

# load environment
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/env.sh" ]]; then
  source "$SCRIPT_DIR/env.sh"
fi

RESET_HIDDEN="\[$RESET\]"
FG_BLACK="${FG_RGB}${BLACK}m"
FG_BLACK_HIDDEN="\[$FG_BLACK\]"
FG_WHITE="${FG_RGB}${WHITE}m"
FG_WHITE_HIDDEN="\[$FG_WHITE\]"
BG_WHITE="${BG_RGB}${WHITE}m"
BG_WHITE_HIDDEN="\[$BG_WHITE\]"
BG_BLUE="${BG_RGB}${BLUE}m"
BG_BLUE_HIDDEN="\[$BG_BLUE\]"
FG_BLUE="${FG_RGB}${BLUE}m"
FG_BLUE_HIDDEN="\[$FG_BLUE\]"
BG_YELLOW="${BG_RGB}${YELLOW}m"
BG_YELLOW_HIDDEN="\[$BG_YELLOW\]"
FG_YELLOW="${FG_RGB}${YELLOW}m"
FG_YELLOW_HIDDEN="\[$FG_YELLOW}\]"
BG_GREEN="${BG_RGB}${GREEN}m"
BG_GREEN_HIDDEN="\[$BG_GREEN\]"
FG_GREEN="${FG_RGB}${GREEN}m"
FG_GREEN_HIDDEN="\[$FG_GREEN\]"

parse_git_dirty() {
  [[ -n $(git status --porcelain 2>/dev/null) ]] && echo '*'
}

parse_git_remote() {
  if [[ -n $(git remote 2>/dev/null) ]]; then
    local remotes=$(git remote -v 2>/dev/null)
    if [[ "$remotes" == *github.com* ]]; then
      printf "${GITHUB_ICON}"
    elif [[ "$remotes" == *bitbucket.org* ]]; then
      printf "${BITBUCKET_ICON}"
    else
      printf "${GITLAB_ICON}"
    fi
  fi
}

parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

formatted_git_branch() {
  if [[ "$(parse_git_branch)" != "" ]]; then
    printf "${BG_YELLOW}${SEPARATOR_RIGHT}${FG_WHITE} $(parse_git_remote) ${BRANCH_ICON} $(parse_git_branch)$(parse_git_dirty) ${RESET}${FG_YELLOW}"
  else
    printf "${FG_BLUE}"
  fi
}

function update_prompt_components() {
  GIT_BRANCH_PRETTY_PROMPT="$(formatted_git_branch)"
  GIT_BRANCH_PROMPT="$(__git_ps1)"
  PROMPT_TIME="$(date +%H:%M)"
  printf "\e]0;%s:%s\007" "${TITLEPREFIX}" "${PWD}" # set title
}

PROMPT_COMMAND=update_prompt_components

simple() {
  PS1="\n\
\[\e[32m\]\u@\h \[\e[35m\]${MSYSTEM} \[\e[33m\]\w\[\e[36m\]\${GIT_BRANCH_PROMPT}\
${RESET_HIDDEN}\n$ "
}

pretty() {
  PS1="\n\
${BG_BLUE_HIDDEN}${FG_WHITE_HIDDEN} ${FOLDER_ICON} \w ${RESET_HIDDEN}${FG_BLUE_HIDDEN}\
\${GIT_BRANCH_PRETTY_PROMPT}\
${SEPARATOR_RIGHT}\
${RESET_HIDDEN}\n$ "
}

minimalistic() {
  PS1="\n\
${BG_BLUE_HIDDEN}${FG_WHITE_HIDDEN} ${FOLDER_ICON} \w ${RESET_HIDDEN}${FG_BLUE_HIDDEN}\
\${GIT_BRANCH_PRETTY_PROMPT}\
${SEPARATOR_RIGHT}\
${RESET_HIDDEN}\n${BG_GREEN_HIDDEN}${FG_WHITE_HIDDEN} $ ${RESET_HIDDEN}${FG_GREEN_HIDDEN}${SEPARATOR_RIGHT}${RESET_HIDDEN} "
}

involved() {
  PS1="\n\
┌${FG_BLUE_HIDDEN}${SEPARATOR_LEFT}${BG_BLUE_HIDDEN}${FG_WHITE_HIDDEN} ${FOLDER_ICON} \w ${RESET_HIDDEN}${FG_BLUE_HIDDEN}\
\${GIT_BRANCH_PRETTY_PROMPT}\
${BG_GREEN_HIDDEN}${SEPARATOR_RIGHT}${FG_WHITE_HIDDEN} ${CLOCK_ICON} \${PROMPT_TIME} ${RESET_HIDDEN}${FG_GREEN_HIDDEN}${SEPARATOR_RIGHT}\
${RESET_HIDDEN}\n╰┈➤ "
}

# setup theme
if [ -n "$BASH_THEME" ]; then
  $BASH_THEME || involved
else
  involved
fi
