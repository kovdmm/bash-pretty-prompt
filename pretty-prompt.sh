#!/bin/bash

if [[ -n "$__BPP_PRETTY_PROMPT_SH_SOURCED" ]]; then
  return
fi
__BPP_PRETTY_PROMPT_SH_SOURCED=1

# source utils
__bpp_load_env() {
  if [[ -f "$BPP_ROOT/env.sh" ]]; then
    source "$BPP_ROOT/env.sh"
  fi
}

# color utils
__bpp_rgb() {
  local esc_prefix=$1
  local rgb=$2
  printf "%s%sm" "$esc_prefix" "$rgb"
}

__bpp_fg_rgb() {
  __bpp_rgb "\e[38;2;" "$1"
}

__bpp_bg_rgb() {
  __bpp_rgb "\e[48;2;" "$1"
}

# terminal utils
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

# git utils
__bpp_git_remote_icon() {
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

__bpp_git_ref() {
  local ref dirty
  ref="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  if [[ -n "$ref" ]]; then
    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
      dirty='*'
    fi
    echo "${ref}${dirty}"
  fi
}

__bpp_git_ref_simple() {
  local ref
  ref="$(__bpp_git_ref)"
  if [[ -n "$ref" ]]; then
    echo " ($ref)"
  fi
}

__bpp_git_ref_pretty() {
  local ref
  ref="$(__bpp_git_ref)"
  if [[ -n "$ref" ]]; then
    echo -e "${BBP_GIT_BG}${BPP_SEP_R}${BPP_MAIN_FG} $(__bpp_git_remote_icon)${BPP_BRANCH_ICON} $ref ${BPP_RESET}${BBP_GIT_FG}"
  else
    echo -e "${BPP_RESET}${BPP_CWD_FG}"
  fi
}

# themes
__bpp_theme_simple() {
  PS1="\`__bpp_title\`\n\
\[\e[32m\]\u@\h $(__bpp_msystem)\[\e[33m\]\w\[\e[36m\]\`__bpp_git_ref_simple\`${BPP_RESET}\n\
$ "
}

__bpp_theme_pretty() {
  PS1="\`__bpp_title\`\n\
${BPP_CWD_BG}${BPP_MAIN_FG} ${BPP_FOLDER_ICON} \w ${BPP_RESET}${BPP_CWD_FG}\
\`__bpp_git_ref_pretty\`${BPP_SEP_R}${BPP_RESET}\n\
$ "
}

__bpp_theme_minimalistic() {
  PS1="\`__bpp_title\`\n\
${BPP_MAIN_FG}${BPP_CWD_BG} ${BPP_FOLDER_ICON} \w ${BPP_CWD_FG}\
\`__bpp_git_ref_pretty\`${BPP_SEP_R}\n\
\[${BBP_TIME_BG}${BPP_MAIN_FG}\] $ \[${BPP_RESET}${BBP_TIME_FG}\]${BPP_SEP_R}\[${BPP_RESET}\] "
}

__bpp_theme_involved() {
  PS1="\`__bpp_title\`\n\
╭${BPP_CWD_FG}${BPP_SEP_L}${BPP_CWD_BG}${BPP_MAIN_FG} ${BPP_FOLDER_ICON} \w ${BPP_RESET}${BPP_CWD_FG}\
\`__bpp_git_ref_pretty\`${BBP_TIME_BG}${BPP_SEP_R}\
${BPP_MAIN_FG} ${BPP_CLOCK_ICON} \`date +%H:%M\` ${BPP_RESET}${BBP_TIME_FG}${BPP_SEP_R}\
\[${BPP_RESET}\]\n\
╰┈➤ "
}

__bpp_setup_theme() {
  local theme
  theme=$1
  if [[ -n "$theme" ]]; then
    if ! "__bpp_theme_$theme" 2>/dev/null; then
      echo "Invalid theme value: '$theme'. Falling back to 'pretty'."
      __bpp_theme_pretty
    fi
  else
    __bpp_theme_pretty
  fi
}

# executing
BPP_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$BPP_ROOT/globals.sh"
__bpp_before_theme_setup 2>/dev/null
__bpp_setup_theme $BPP_THEME
__bpp_after_theme_setup 2>/dev/null
