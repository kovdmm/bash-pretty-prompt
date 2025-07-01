# bash-pretty-prompt

![image](https://github.com/user-attachments/assets/b50805e8-4225-4a19-8030-892966afe09a)

Git-aware Bash prompt with 24-bit colors, Nerd Fonts, and multiple themes.

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
cp env.sh.example env.sh
```

Then edit `env.sh` to customize colors, icons, theme, and other options.
