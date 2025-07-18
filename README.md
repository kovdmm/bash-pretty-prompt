# bash-pretty-prompt

[![image](https://github.com/user-attachments/assets/b50805e8-4225-4a19-8030-892966afe09a)](#bash-pretty-prompt)

Git-aware Bash prompt with 24-bit colors, Nerd Fonts, and multiple themes.

## Dev Tools

VS Code Extensions used:

- [Bash IDE](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)
- [shfmt](https://marketplace.visualstudio.com/items?itemName=mkhl.shfmt)
- [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

Formatting & linting tools used:

- [shfmt](https://pkg.go.dev/mvdan.cc/sh/v3#section-readme) (Go ecosystem) - formats shell scripts (`*.sh`).
- [Prettier](https://prettier.io/docs/install) (JS ecosystem) - formats Markdown (`*.md`) and JSON (`*.json`) files.
- [CSpell](https://cspell.org/docs/installation) (JS ecosystem) - performs spell checking across all file types.

## Disclaimer

This script was built through trial and error for personal use. It’s not perfect, not minimal, and not meant to be. Bash has serious limitations for things like real-time clock updates, `RPROMPT`, or reacting to terminal events (`SIGWINCH`, `SIGCONT`, etc.).

A proper solution would be a separate tool written in another language — something that can render prompts from config or args, listen to terminal signals, and update in place. Until then, this script just works — and that's enough.

## Installation, configuration and customization

### How to install?

Add the following to the end of your `~/.bashrc`:

```bash
# Custom prompt definitions.
if [ -f "/path/to/bash-pretty-prompt/pretty-prompt.sh" ]; then
  source "/path/to/bash-pretty-prompt/pretty-prompt.sh"
fi
```

Make sure to replace `/path/to/bash-pretty-prompt/pretty-prompt.sh` with the actual path to `pretty-prompt.sh` file.

**Note:** To display icons correctly, make sure you have a [Nerd Font](https://www.nerdfonts.com/) installed and selected in your terminal.

### How to configure?

Copy the example config:

```bash
cp example.env.sh env.sh
```

Then edit `env.sh` to customize colors, icons, theme, and other options.
