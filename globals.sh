#!/bin/bash

if [[ -n "$__BPP_GLOBALS_SH_SOURCED" ]]; then
  return
fi
__BPP_GLOBALS_SH_SOURCED=1

# setup preset functions
__bpp_setup_icons_preset() {
  if [[ "$BPP_ICONS" == "nerd_font" ]]; then
    BPP_FOLDER_ICON=$'\uf115 '   # 
    BPP_BRANCH_ICON=$'\uf418 '   # 
    BPP_CLOCK_ICON=$'\uf43a '    # 
    BPP_GITHUB_ICON=$'\ue709 '   # 
    BPP_GITLAB_ICON=$'\ue7eb '   # 
    BPP_BITBUCKET_ICON=$'\uf171' # 
  elif [[ "$BPP_ICONS" == "emoji" ]]; then
    BPP_FOLDER_ICON=$'\ud83d\udcc2 '    # 📂
    BPP_BRANCH_ICON=$'\ud83c\udf3f '    # 🌿
    BPP_CLOCK_ICON=$'\ud83d\udd57 '     # 🕗
    BPP_GITHUB_ICON=$'\ud83d\udc19 '    # 🐙
    BPP_GITLAB_ICON=$'\ud83e\udd8a '    # 🦊
    BPP_BITBUCKET_ICON=$'\ud83e\uddfa ' # 🧺
  else
    BPP_FOLDER_ICON=
    BPP_BRANCH_ICON=
    BPP_CLOCK_ICON=
    BPP_GITHUB_ICON=
    BPP_GITLAB_ICON=
    BPP_BITBUCKET_ICON=
  fi
}

__bpp_setup_separators_preset() {
  if [[ "$BPP_SEPARATORS" == "powerline" ]]; then
    BPP_SEP_R=$'\ue0b0' # 
    BPP_SEP_L=$'\ue0b2' # 
  elif [[ "$BPP_SEPARATORS" == "unicode" ]]; then
    BPP_SEP_R=$'\u25b6' # ▶
    BPP_SEP_L=$'\u25c0' # ◀
  else
    BPP_SEP_R=
    BPP_SEP_L=
  fi
}

# global variables
BPP_RESET="\e[0m"
BPP_FG_RESET="\e[39m"
BPP_BG_RESET="\e[49m"

BPP_FG_MAIN_RGB="255;255;255"
BPP_BG_CWD_RGB="22;62;103"
BPP_BG_GIT_RGB="110;80;0"
BPP_BG_TIME_RGB="40;127;119"

BPP_THEME="pretty"
BPP_ICONS="nerd_font"
BPP_SEPARATORS="powerline"

# override global variables
__bpp_load_env

# calculated global variables
BPP_MAIN_FG="$(__bpp_fg_rgb "$BPP_FG_MAIN_RGB")"
BPP_CWD_BG="$(__bpp_bg_rgb "$BPP_BG_CWD_RGB")"
BPP_CWD_FG="$(__bpp_fg_rgb "$BPP_BG_CWD_RGB")"
BBP_GIT_BG="$(__bpp_bg_rgb "$BPP_BG_GIT_RGB")"
BBP_GIT_FG="$(__bpp_fg_rgb "$BPP_BG_GIT_RGB")"
BBP_TIME_BG="$(__bpp_bg_rgb "$BPP_BG_TIME_RGB")"
BBP_TIME_FG="$(__bpp_fg_rgb "$BPP_BG_TIME_RGB")"

__bpp_setup_icons_preset
__bpp_setup_separators_preset

BPP_TITLE="[Pretty Bash] $(whoami)@$(hostname): $(pwd)"

# override calculated global variables
__bpp_load_env

export BPP_RESET BPP_FG_RESET BPP_BG_RESET \
  BPP_SEP_R BPP_SEP_L \
  BPP_THEME BPP_NERD_FONT_ICONS \
  BPP_FOLDER_ICON BPP_BRANCH_ICON BPP_CLOCK_ICON BPP_GITHUB_ICON BPP_GITLAB_ICON BPP_BITBUCKET_ICON \
  BPP_MAIN_FG BPP_CWD_BG BPP_CWD_FG BBP_GIT_BG BBP_GIT_FG BBP_TIME_BG BBP_TIME_FG \
  BPP_TITLE
