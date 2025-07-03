#!/bin/bash

BPP_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$BPP_ROOT/globals.sh"

__bpp_before_exec 2>/dev/null

__bpp_git_remote() {
  if [[ -n "$(git remote 2>/dev/null)" ]]; then
    local remotes
    remotes=$(git remote -v 2>/dev/null)
    if [[ "$remotes" == *github.com* ]]; then
      echo -n "$BPP_GITHUB_ICON"
    elif [[ "$remotes" == *bitbucket.org* ]]; then
      echo -n "$BPP_BITBUCKET_ICON"
    else
      echo -n "$BPP_GITLAB_ICON"
    fi
    echo -n " "
  fi
}

__bpp_git_dirty() {
  [[ -n "$(git status --porcelain 2>/dev/null)" ]] && echo '*'
}

__bpp_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

__bpp_git_branch_simple() {
  if [[ -n "$(__bpp_git_branch)" ]]; then
    echo " ($(__bpp_git_branch)$(__bpp_git_dirty))"
  fi
}

__bpp_git_branch_pretty() {
  if [[ -n "$(__bpp_git_branch)" ]]; then
    echo -e "${BBP_GIT_BG}${BPP_SEP_R}${BPP_MAIN_FG} $(__bpp_git_remote)${BPP_BRANCH_ICON} $(__bpp_git_branch)$(__bpp_git_dirty) ${BPP_RESET}${BBP_GIT_FG}"
  else
    echo -e "${BPP_RESET}${BPP_CWD_FG}"
  fi
}

__bpp_title() {
  if [[ -n "$BPP_TITLE" ]]; then
    printf "\e]0;%s\007" "$BPP_TITLE"
  else
    printf "\e]0;%s\007" "$TITLEPREFIX: $PWD"
  fi
}

__bpp_msystem() {
  if [[ -n $MSYSTEM ]]; then
    printf "\[\e[35m\]%s " "$MSYSTEM"
  fi
}

__bpp_theme_simple() {
  PS1="\`__bpp_title\`\n\
\[\e[32m\]\u@\h $(__bpp_msystem)\[\e[33m\]\w\[\e[36m\]\`__bpp_git_branch_simple\`${BPP_RESET}\n\
$ "
}

__bpp_theme_pretty() {
  PS1="\`__bpp_title\`\n\
${BPP_CWD_BG}${BPP_MAIN_FG} ${BPP_FOLDER_ICON} \w ${BPP_RESET}${BPP_CWD_FG}\
\`__bpp_git_branch_pretty\`${BPP_SEP_R}${BPP_RESET}\n\
$ "
}

__bpp_theme_minimalistic() {
  PS1="\`__bpp_title\`\n\
${BPP_MAIN_FG}${BPP_CWD_BG} ${BPP_FOLDER_ICON} \w ${BPP_CWD_FG}\
\`__bpp_git_branch_pretty\`${BPP_SEP_R}\n\
\[${BBP_TIME_BG}${BPP_MAIN_FG}\] $ \[${BPP_RESET}${BBP_TIME_FG}\]${BPP_SEP_R}\[${BPP_RESET}\] "
}

__bpp_theme_involved() {
  PS1="\`__bpp_title\`\n\
╭${BPP_CWD_FG}${BPP_SEP_L}${BPP_CWD_BG}${BPP_MAIN_FG} ${BPP_FOLDER_ICON} \w ${BPP_RESET}${BPP_CWD_FG}\
\`__bpp_git_branch_pretty\`${BBP_TIME_BG}${BPP_SEP_R}\
${BPP_MAIN_FG} ${BPP_CLOCK_ICON} \`date +%H:%M\` ${BPP_RESET}${BBP_TIME_FG}${BPP_SEP_R}\
\[${BPP_RESET}\]\n\
╰┈➤ "
}

# setup theme
if [[ -n "$BPP_THEME" ]]; then
  if ! "__bpp_theme_$BPP_THEME" 2>/dev/null; then
    echo "Invalid BPP_THEME value: '$BPP_THEME'. Falling back to 'pretty'."
    __bpp_theme_pretty
  fi
else
  __bpp_theme_pretty
fi

__bpp_after_exec 2>/dev/null
