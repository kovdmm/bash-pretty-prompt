#!/bin/bash

if [[ -n "$__BPP_HELPERS_SH_SOURCED" ]]; then
  return
fi
__BPP_HELPERS_SH_SOURCED=1

__bpp_load_env() {
  if [[ -f "$BPP_ROOT/env.sh" ]]; then
    source "$BPP_ROOT/env.sh"
  fi
}

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
