#!/bin/bash

if [[ -n "$__BPP_SH_SOURCED" ]]; then
  return
fi
__BPP_SH_SOURCED=1

__BPP_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BPP_ROOT="$(dirname "$__BPP_SOURCE_DIR")"
BPP_ENV="$BPP_ROOT/env.sh"

BPP_OPTIONS=(setup theme icons separators status help)
BPP_VALID_THEMES=(simple pretty minimalistic involved)
BPP_ICON_PRESETS=(nerd_font emoji none)
BPP_SEPARATOR_PRESETS=(powerline unicode none)
BPP_STATUS_OPTIONS=(enable disable)
BPP_HELP_OPTIONS=(help -h --help)

__bpp_cli() {
  __BPP_OPTION="$1"
  __BPP_VALUE="$2"
  case "$__BPP_OPTION" in
  setup)
    if __bpp_is_help; then
      echo -e "Usage: bpp setup\n\nIntegrates the prompt into your shell (~/.bashrc) and prepares the configuration file (env.sh) for customization."
      return
    fi
    __bpp_bootstrap_env || return 1
    __bpp_integrate_shell || return 1
    ;;
  theme)
    __BPP_USAGE="Usage: bpp theme <theme-name> (one of: simple, pretty, minimalistic, involved)"
    __BPP_ALLOWED_VALUES=("${BPP_VALID_THEMES[@]}")
    __BPP_CURRENT_VALUE="$BPP_THEME"
    __BPP_ENV_VAR="BPP_THEME"
    __bpp_cli_validate_config_and_apply_changes || return 1
    ;;
  icons)
    __BPP_USAGE="Usage: bpp icons <preset> (one of: nerd_font, emoji, none)"
    __BPP_ALLOWED_VALUES=("${BPP_ICON_PRESETS[@]}")
    __BPP_CURRENT_VALUE="$BPP_ICONS"
    __BPP_ENV_VAR="BPP_ICONS"
    __bpp_cli_validate_config_and_apply_changes __bpp_setup_icons_preset || return 1
    ;;
  separators)
    __BPP_USAGE="Usage: bpp separators <preset> (one of: powerline, unicode, none)"
    __BPP_ALLOWED_VALUES=("${BPP_SEPARATOR_PRESETS[@]}")
    __BPP_CURRENT_VALUE="$BPP_SEPARATORS"
    __BPP_ENV_VAR="BPP_SEPARATORS"
    __bpp_cli_validate_config_and_apply_changes __bpp_setup_separators_preset || return 1
    ;;
  status)
    __BPP_USAGE="Usage: bpp status <enable|disable>"
    __BPP_ALLOWED_VALUES=("${BPP_STATUS_OPTIONS[@]}")
    __BPP_CURRENT_VALUE="$BPP_STATUS"
    __BPP_ENV_VAR="BPP_STATUS"
    __bpp_cli_validate_config_and_apply_changes || return 1
    ;;
  help | --help | -h | '')
    __bpp_cli_help
    ;;
  *)
    echo "Error: unknown command '$1'." >&2
    echo "See 'bpp help' for available commands." >&2
    return 1
    ;;
  esac
}

__bpp_is_help() {
  if [[ " ${BPP_HELP_OPTIONS[*]} " == *" $__BPP_VALUE "* ]]; then
    return 0 # true
  fi
  return 1 # false
}

__bpp_integrate_shell() {
  local bashrc="$HOME/.bashrc"
  local shell marker_line line_count
  local target_if target_source escaped_target_if escaped_target_source
  local existing_if existing_source existing_fi

  shell="$BPP_ROOT/pretty-prompt.sh"
  target_if="if [[ -f \"$shell\" ]]; then"
  target_source="  source \"$shell\""

  if [[ ! -f "$bashrc" ]]; then
    : >"$bashrc" || {
      echo "Cannot create ~/.bashrc" >&2
      return 1
    }
  fi

  marker_line="$(grep -n -m1 '^# bash-pretty-prompt$' "$bashrc" | cut -d: -f1)"

  echo "bash-pretty-prompt root: '$BPP_ROOT'"
  if [[ -z "$marker_line" ]]; then
    __bpp_write_integration_block "$bashrc"
    echo "bash-pretty-prompt integrated successfully"
  else
    line_count="$(wc -l <"$bashrc")"
    if ((line_count < marker_line + 3)); then
      sed -i "${marker_line},\$d" "$bashrc"
      __bpp_write_integration_block "$bashrc"
      echo "bash-pretty-prompt integration path updated"
    else
      existing_if="$(sed -n "$((marker_line + 1))p" "$bashrc")"
      existing_source="$(sed -n "$((marker_line + 2))p" "$bashrc")"
      existing_fi="$(sed -n "$((marker_line + 3))p" "$bashrc")"

      escaped_target_if="$(__bpp_escape_sed_replacement "$target_if")"
      escaped_target_source="$(__bpp_escape_sed_replacement "$target_source")"
      sed -i "${marker_line}s|.*|# bash-pretty-prompt|" "$bashrc"
      sed -i "$((marker_line + 1))s|.*|$escaped_target_if|" "$bashrc"
      sed -i "$((marker_line + 2))s|.*|$escaped_target_source|" "$bashrc"
      sed -i "$((marker_line + 3))s|.*|fi|" "$bashrc"

      if [[ "$existing_if" == "$target_if" && "$existing_source" == "$target_source" && "$existing_fi" == "fi" ]]; then
        echo "bash-pretty-prompt is already integrated"
      else
        echo "bash-pretty-prompt integration path updated"
      fi
    fi
  fi
  echo "To see changes, start a new bash session (run: bash)"
}

__bpp_escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

__bpp_write_integration_block() {
  local output_file="$1"
  local shell="$BPP_ROOT/pretty-prompt.sh"
  {
    echo
    echo "# bash-pretty-prompt"
    echo "if [[ -f \"$shell\" ]]; then"
    echo "  source \"$shell\""
    echo "fi"
  } >>"$output_file"
}

__bpp_bootstrap_env() {
  if [[ -f "$BPP_ROOT/env.sh" ]]; then
    echo "The env.sh file is already created"
  else
    if cp "$BPP_ROOT/example.env.sh" "$BPP_ROOT/env.sh"; then
      echo "The env.sh file created successfully"
    else
      echo "Cannot create $BPP_ROOT/env.sh file" >&2
      exit 1
    fi
  fi
}

__bpp_cli_validate_config_and_apply_changes() {
  local allowed_value_pattern setup_function
  setup_function="$1"
  # current value
  if [[ -z "$__BPP_VALUE" ]]; then
    if [[ -n "$__BPP_CURRENT_VALUE" ]]; then
      echo "Current value: '$__BPP_CURRENT_VALUE'"
    fi
    echo "$__BPP_USAGE"
    return
  fi
  # help
  if __bpp_is_help; then
    echo -e "$__BPP_USAGE\n\nSets $__BPP_ENV_VAR in env.sh and applies the change to the current terminal if possible."
    return
  fi
  # allowed value
  if [[ ! " ${__BPP_ALLOWED_VALUES[*]} " == *" $__BPP_VALUE "* ]]; then
    echo "Error: unknown value '$__BPP_VALUE'" >&2
    echo "$__BPP_USAGE" >&2
    return 1
  fi
  # create env.sh file if not exist
  if [[ ! -f "$BPP_ENV" ]]; then
    __bpp_bootstrap_env 1>/dev/null || return 1
  fi
  # replace or add line in env.sh
  local new_line="${__BPP_ENV_VAR}=\"${__BPP_VALUE}\""
  sed -i "s/^${__BPP_ENV_VAR}=.*/${new_line}/" "$BPP_ENV"
  if ! grep -q "^${__BPP_ENV_VAR}=" "$BPP_ENV"; then
    echo -e "\n${new_line}" >>"$BPP_ENV"
  fi
  echo "The $__BPP_ENV_VAR value set to '$__BPP_VALUE' in env.sh"
  # apply changes live if possible
  export "${__BPP_ENV_VAR}"="$__BPP_VALUE"
  if [[ -n "$setup_function" ]] && declare -F "$setup_function" >/dev/null; then
    "$setup_function"
  fi
  if __bpp_setup_theme "$BPP_THEME" 2>/dev/null; then
    echo "The $__BPP_ENV_VAR value set to '$__BPP_VALUE' in terminal"
  fi
}

__bpp_cli_help() {
  cat <<EOF
Usage: bpp <command> [options]

Commands:
  setup                Integrate the prompt into your shell (~/.bashrc)
                       and prepare the configuration file (env.sh) if needed.
  theme <theme-name>   Set prompt theme (simple, pretty, minimalistic, involved)
  icons <preset>       Set icons preset (nerd_font, emoji, none)
  separators <preset>  Set separators preset (powerline, unicode, none)
  status <mode>        Toggle success/error status icon (enable, disable)
  help                 Show this help message

Examples:
  bpp setup
  bpp theme involved
  bpp icons emoji
  bpp separators powerline
  bpp status enable
EOF
}

# autocomplete
__bpp_complete() {
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  if [[ $COMP_CWORD -eq 1 ]]; then
    mapfile -t COMPREPLY < <(compgen -W "${BPP_OPTIONS[*]}" -- "$cur")
    return 0
  fi

  if [[ $COMP_CWORD -eq 2 && $prev == "theme" ]]; then
    mapfile -t COMPREPLY < <(compgen -W "${BPP_VALID_THEMES[*]}" -- "$cur")
    return 0
  fi

  if [[ $COMP_CWORD -eq 2 && $prev == "icons" ]]; then
    mapfile -t COMPREPLY < <(compgen -W "${BPP_ICON_PRESETS[*]}" -- "$cur")
    return 0
  fi

  if [[ $COMP_CWORD -eq 2 && $prev == "separators" ]]; then
    mapfile -t COMPREPLY < <(compgen -W "${BPP_SEPARATOR_PRESETS[*]}" -- "$cur")
    return 0
  fi

  if [[ $COMP_CWORD -eq 2 && $prev == "status" ]]; then
    mapfile -t COMPREPLY < <(compgen -W "${BPP_STATUS_OPTIONS[*]}" -- "$cur")
    return 0
  fi

}
