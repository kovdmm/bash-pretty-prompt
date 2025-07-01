#!/bin/bash
# shellcheck disable=SC2034

# Prompt theme: simple | pretty | minimalistic | involved
BPP_THEME="pretty"

# Set to "false" if your terminal doesn't support Nerd Fonts (icons will fall back to emojis)
BPP_NERD_FONT_ICONS="true"

# Terminal window title (supports variables and command substitution)
BPP_TITLE="$(whoami): $PWD"

# RGB colors in format "R;G;B" (each component: 0–255)
BPP_FG_MAIN_RGB="255;255;255" # Foreground text color
BPP_BG_CWD_RGB="22;62;103"    # Background color for current working directory section
BPP_BG_GIT_RGB="110;80;0"     # Background color for Git section
BPP_BG_TIME_RGB="40;127;119"  # Background color for time section
