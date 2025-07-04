#!/bin/bash
# shellcheck disable=SC2034

# Prompt theme: simple | pretty | minimalistic | involved
BPP_THEME="pretty"

# Prompt icons: nerd_font | emoji | none
BPP_ICONS="nerd_font"

# Prompt separators: powerline | unicode | none
BPP_SEPARATORS="powerline"

# Terminal window title (supports variables and command substitution)
BPP_TITLE="[Pretty Bash] $(whoami)@$(hostname): $(pwd)"

# RGB colors in format "R;G;B" (each component: 0–255)
BPP_FG_MAIN_RGB="255;255;255" # Foreground text color
BPP_BG_CWD_RGB="22;62;103"    # Background color for current working directory section
BPP_BG_GIT_RGB="110;80;0"     # Background color for Git section
BPP_BG_TIME_RGB="40;127;119"  # Background color for time section
