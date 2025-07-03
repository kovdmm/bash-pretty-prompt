#!/bin/bash

if [[ -n "$__BPP_GLOBALS_SH_SOURCED" ]]; then
  return
fi
__BPP_GLOBALS_SH_SOURCED=1

# global variables
BPP_FG_MAIN_RGB="255;255;255"
BPP_BG_CWD_RGB="22;62;103"
BPP_BG_GIT_RGB="110;80;0"
BPP_BG_TIME_RGB="40;127;119"

BPP_RESET="\e[0m"
BPP_FG_RESET="\e[39m"
BPP_BG_RESET="\e[49m"

BPP_SEP_R=""
BPP_SEP_L=""

BPP_THEME="pretty"
BPP_NERD_FONT_ICONS="false"

# override global variables
__bpp_load_env

# calculated global variables
if [[ "$BPP_NERD_FONT_ICONS" == "true" ]]; then
  BPP_FOLDER_ICON=$'\uf115'    # 
  BPP_BRANCH_ICON=$'\uf418'    # 
  BPP_CLOCK_ICON=$'\uf43a'     # 
  BPP_GITHUB_ICON=$'\ue709'    # 
  BPP_GITLAB_ICON=$'\ue7eb'    # 
  BPP_BITBUCKET_ICON=$'\uf171' # 
else
  BPP_FOLDER_ICON=$'\ud83d\udcc2'    # 📂
  BPP_BRANCH_ICON=$'\ud83c\udf3f'    # 🌿
  BPP_CLOCK_ICON=$'\ud83d\udd57'     # 🕗
  BPP_GITHUB_ICON=$'\ud83d\udc19'    # 🐙
  BPP_GITLAB_ICON=$'\ud83e\udd8a'    # 🦊
  BPP_BITBUCKET_ICON=$'\ud83e\uddfa' # 🧺
fi

BPP_MAIN_FG="$(__bpp_fg_rgb "$BPP_FG_MAIN_RGB")"
BPP_CWD_BG="$(__bpp_bg_rgb "$BPP_BG_CWD_RGB")"
BPP_CWD_FG="$(__bpp_fg_rgb "$BPP_BG_CWD_RGB")"
BBP_GIT_BG="$(__bpp_bg_rgb "$BPP_BG_GIT_RGB")"
BBP_GIT_FG="$(__bpp_fg_rgb "$BPP_BG_GIT_RGB")"
BBP_TIME_BG="$(__bpp_bg_rgb "$BPP_BG_TIME_RGB")"
BBP_TIME_FG="$(__bpp_fg_rgb "$BPP_BG_TIME_RGB")"

BPP_TITLE="${TITLEPREFIX}:${PWD}"

# override calculated global variables
__bpp_load_env

export BPP_RESET BPP_FG_RESET BPP_BG_RESET \
  BPP_SEP_R BPP_SEP_L \
  BPP_THEME BPP_NERD_FONT_ICONS \
  BPP_FOLDER_ICON BPP_BRANCH_ICON BPP_CLOCK_ICON BPP_GITHUB_ICON BPP_GITLAB_ICON BPP_BITBUCKET_ICON \
  BPP_MAIN_FG BPP_CWD_BG BPP_CWD_FG BBP_GIT_BG BBP_GIT_FG BBP_TIME_BG BBP_TIME_FG \
  BPP_TITLE
