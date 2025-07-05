#!/bin/bash

if [[ -n "$__BPP_SH_SOURCED" ]]; then
  return
fi
__BPP_SH_SOURCED=1

__BPP_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BPP_ROOT="$(dirname "$__BPP_SOURCE_DIR")"
BPP_ENV="$BPP_ROOT/env.sh"

BPP_COMMANDS=(setup theme icons separators fix help)
BPP_VALID_THEMES=(simple pretty minimalistic involved)
BPP_ICON_PRESETS=(nerd_font emoji none)
BPP_SEPARATOR_PRESETS=(powerline unicode none)
BPP_FIX_OPTIONS=(vscode)
BPP_HELP_OPTIONS=(help -h --help)
BPP_SETUP_OPTIONS=__bpp_cli_setup
BPP_FIX_OPTIONS=(["vscode"]="__bpp_cli_fix_vscode")

__bpp_cli() {
  __BPP_COMMAND="$1"
  __BPP_OPTION="$2"
  case "$__BPP_COMMAND" in
  setup)
    __BPP_USAGE="Usage: bpp setup\n\nIntegrates the prompt into your shell (~/.bashrc) and prepares the configuration file (env.sh) for customization."
    __BPP_ALLOWED_OPTIONS=("${BPP_SETUP_OPTIONS[@]}")
    __bpp_cli_perform_option
    __bpp_bootstrap_env || return 1
    __bpp_integrate_shell || return 1
    ;;
  theme)
    __BPP_USAGE="Usage: bpp theme <theme-name> (one of: simple, pretty, minimalistic, involved)"
    __BPP_ALLOWED_VALUES=("${BPP_VALID_THEMES[@]}")
    __BPP_ENV_VAR="BPP_THEME"
    __bpp_cli_validate_config_and_apply_changes || return 1
    ;;
  icons)
    __BPP_USAGE="Usage: bpp icons <preset> (one of: nerd_font, emoji, none)"
    __BPP_ALLOWED_VALUES=("${BPP_ICON_PRESETS[@]}")
    __BPP_ENV_VAR="BPP_ICONS"
    __BPP_UPDATE_PRESET_HOOK="__bpp_setup_icons_preset"
    __bpp_cli_validate_config_and_apply_changes || return 1
    ;;
  separators)
    __BPP_USAGE="Usage: bpp separators <preset> (one of: powerline, unicode, none)"
    __BPP_ALLOWED_VALUES=("${BPP_SEPARATOR_PRESETS[@]}")
    __BPP_ENV_VAR="BPP_SEPARATORS"
    __BPP_UPDATE_PRESET_HOOK="__bpp_setup_separators_preset"
    __bpp_cli_validate_config_and_apply_changes || return 1
    ;;
  fix)
    __BPP_USAGE="Usage: bpp fix <target> (one of: unicode\n\nApplies fixes for prompt-related stuff in configuration file (env.sh)."
    if __bpp_is_help; then
      echo -e "Usage: bpp fix\n\nApplies fixes for prompt-related stuff in configuration file (env.sh)."
      return
    fi
    __bpp_cli_command
    case "$__BPP_OPTION" in
    vscode)
      echo "TODO: vscode (fix coloring)" # TODO: vscode (fix coloring)
      echo "See 'bpp help' for available commands." >&2
      ;;
    *)
      echo "Error: unknown command '$1'." >&2
      ;;
    esac
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

__bpp_cli_perform_option() {
  # current value
  if [[ -z "$__BPP_OPTION" ]]; then
    if [[ -n "${!__BPP_ENV_VAR}" ]]; then
      echo "Current value: '${!__BPP_ENV_VAR}'"
    fi
    echo "$__BPP_USAGE"
    return
  fi
  # help
  if __bpp_is_help; then
    echo -e "$__BPP_USAGE\n\nSets $__BPP_ENV_VAR in env.sh and applies the change to the current terminal if possible."
    return
  fi
}

__bpp_is_help() {
  if [[ " ${BPP_HELP_OPTIONS[*]} " == *" $__BPP_OPTION "* ]]; then
    return 0 # true
  fi
  return 1 # false
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

__bpp_integrate_shell() {
  if grep -q pretty-prompt.sh ~/.bashrc; then
    echo "bash-pretty-prompt is already integrated"
  else
    echo "bash-pretty-prompt root: '$BPP_ROOT'"
    if __bpp_append_bashrc "$BPP_ROOT/pretty-prompt.sh"; then
      echo "bash-pretty-prompt integrated successfully"
      echo "To see changes, start a new bash session (run: bash)"
    else
      echo "Cannot integrate bash-pretty-prompt" >&2
      exit 1
    fi
  fi
}

__bpp_append_bashrc() {
  local shell="$1"
  echo -e "\n# bash-pretty-prompt\nif [[ -f \"$shell\" ]]; then\n  source \"$shell\"\nfi" >>~/.bashrc
}

__bpp_cli_validate_config_and_apply_changes() {
  # current value
  if [[ -z "$__BPP_OPTION" ]]; then
    if [[ -n "${!__BPP_ENV_VAR}" ]]; then
      echo "Current value: '${!__BPP_ENV_VAR}'"
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
  if ! [[ " ${__BPP_ALLOWED_VALUES[*]} " == *" $__BPP_OPTION "* ]]; then
    echo "Error: unknown value '$__BPP_OPTION'" >&2
    echo "$__BPP_USAGE" >&2
    return 1
  fi
  # create env.sh file if not exist
  if ! [[ -f "$BPP_ENV" ]]; then
    __bpp_bootstrap_env 1>/dev/null || return 1
  fi
  # replace or add line in env.sh
  local new_line="${__BPP_ENV_VAR}=\"${__BPP_OPTION}\""
  sed -i "s/^${__BPP_ENV_VAR}=.*/${new_line}/" "$BPP_ENV"
  if ! grep -q "^${__BPP_ENV_VAR}=" "$BPP_ENV"; then
    echo -e "\n${new_line}" >>"$BPP_ENV"
  fi
  echo "The $__BPP_ENV_VAR value set to '$__BPP_OPTION' in env.sh"
  # apply changes live if possible
  export "${__BPP_ENV_VAR}"="$__BPP_OPTION"
  if [[ -n "$__BPP_UPDATE_PRESET_HOOK" ]]; then
    $__BPP_UPDATE_PRESET_HOOK
  fi
  if __bpp_setup_theme "$BPP_THEME" 2>/dev/null; then
    echo "The $__BPP_ENV_VAR value set to '$__BPP_OPTION' in terminal"
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
  help                 Show this help message

Examples:
  bpp setup
  bpp theme involved
  bpp icons emoji
  bpp separators powerline
EOF
}

# autocomplete
__bpp_cli_complete() {
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  if [[ $COMP_CWORD -eq 1 ]]; then
    mapfile -t COMPREPLY < <(compgen -W "${BPP_COMMANDS[*]}" -- "$cur")
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

  if [[ $COMP_CWORD -eq 2 && $prev == "fix" ]]; then
    mapfile -t COMPREPLY < <(compgen -W "${BPP_FIX_OPTIONS[*]}" -- "$cur")
    return 0
  fi
}
