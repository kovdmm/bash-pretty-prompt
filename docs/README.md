# Project Documentation

This document is the single entrypoint for repository documentation beyond the main [README.md](../README.md).

It covers:

- architecture and runtime behavior;
- repository structure;
- local contributor workflow.

## Contents

- [Architecture overview](#architecture-overview)
- [Development guide](#development-guide)

## Architecture overview

This section explains how `@kovdmm/bpp` is structured and how the prompt works from installation to runtime.

### High-level design

The project is a Bash prompt packaged as an npm CLI. Node.js is only used for distribution: the actual product is implemented in shell scripts.

At a high level, the program has four layers:

1. **CLI entrypoint**: resolves where the package is installed and starts the shell CLI.
2. **Configuration CLI**: manages setup, `env.sh`, and live configuration updates.
3. **Prompt runtime**: builds `PS1`, hooks into `PROMPT_COMMAND`, and renders Git/status sections.
4. **Defaults and presets**: defines themes, icons, separators, colors, and applies user overrides.

### Main modules

#### [cli/bpp](../cli/bpp)

This is the executable published through the `bin` field in [package.json](../package.json).

Responsibilities:

- resolve the real directory of the launcher, including symlink traversal;
- find [cli.sh](../cli/cli.sh) even when npm places `bpp` into a separate global `bin` directory;
- source the CLI implementation and forward command-line arguments to `__bpp_cli`.

This file is intentionally small: it only bootstraps the actual CLI.

#### [cli/cli.sh](../cli/cli.sh)

This is the command layer shared by both:

- the standalone `bpp` executable;
- the `bpp` shell alias registered after the prompt is sourced.

Core responsibilities:

- expose commands: `setup`, `theme`, `icons`, `separators`, `status`, `help`;
- create `env.sh` from [example.env.sh](../example.env.sh);
- integrate the prompt into `~/.bashrc`;
- update configuration values in `env.sh`;
- apply configuration changes to the current terminal session when possible;
- provide Bash completion for the CLI.

Important implementation detail:

- `__bpp_sed_inplace` avoids `sed -i` because GNU `sed` and BSD/macOS `sed` use different syntax. Instead, it writes through a temporary file, which keeps the edit path portable.

#### [pretty-prompt.sh](../pretty-prompt.sh)

This is the runtime entrypoint that a shell session actually sources from `~/.bashrc`.

Responsibilities:

- initialize `BPP_ROOT`;
- load shared globals from [globals.sh](../globals.sh);
- hook `__bpp_capture_exit_code` into `PROMPT_COMMAND`;
- choose and apply a theme;
- define prompt rendering helpers for title, Git metadata, and command status;
- expose CLI functions as shell aliases for live reconfiguration.

This script is where the prompt becomes active for the current shell.

#### [globals.sh](../globals.sh)

This file contains the shared configuration model.

It defines:

- default option values such as theme, icons, separators, and status mode;
- color conversion helpers output consumed by prompt rendering;
- icon presets (`nerd_font`, `emoji`, `none`);
- separator presets (`powerline`, `unicode`, `none`);
- exported variables used by the runtime and CLI.

It also loads user overrides from `env.sh` before and after computing derived values so users can override both raw settings and computed prompt variables.

#### [example.env.sh](../example.env.sh)

This is the user-facing configuration template. During `bpp setup`, it is copied to `env.sh` if the file does not already exist.

### End-to-end flow

#### Installation

The package is installed globally with npm. npm exposes the `bpp` executable defined in [package.json](../package.json).

#### Setup

When the user runs `bpp setup`:

1. [cli/bpp](../cli/bpp) resolves the installed package location.
2. It sources [cli/cli.sh](../cli/cli.sh).
3. `__bpp_cli setup` creates `env.sh` from the template if needed.
4. `__bpp_integrate_shell` appends or updates a managed block in `~/.bashrc`.
5. That block sources [pretty-prompt.sh](../pretty-prompt.sh) on future shell startup.

#### Shell startup

When a new Bash session starts and the integration block runs:

1. [pretty-prompt.sh](../pretty-prompt.sh) is sourced.
2. It sources [globals.sh](../globals.sh).
3. [globals.sh](../globals.sh) loads `env.sh` overrides and computes exported prompt variables.
4. [pretty-prompt.sh](../pretty-prompt.sh) installs the exit-code hook in `PROMPT_COMMAND`.
5. The selected theme generates the final `PS1`.
6. The shell gets `bpp` and `bash-pretty-prompt` aliases pointing to `__bpp_cli`.

#### Prompt rendering during use

For every command cycle:

1. `PROMPT_COMMAND` captures the previous command's exit status into `BPP_LAST_EXIT_CODE`.
2. `PS1` executes helper functions while rendering.
3. The prompt can show:
   - the command status icon;
   - the terminal title;
   - the current working directory;
   - Git branch and dirty state;
   - Git hosting icon;
   - current time for the more advanced themes.

### Configuration model

There are two configuration paths:

- **Persistent configuration**: edit `env.sh` manually or via CLI commands such as `bpp theme involved`.
- **Runtime configuration**: once the prompt is loaded, CLI commands can also update exported values in the current shell so the user sees the new theme immediately.

This split is the reason [pretty-prompt.sh](../pretty-prompt.sh) sources [cli/cli.sh](../cli/cli.sh) and exposes `__bpp_cli` as an alias instead of relying only on the external executable.

### Theme architecture

Themes are implemented as separate functions inside [pretty-prompt.sh](../pretty-prompt.sh):

- `__bpp_theme_simple`
- `__bpp_theme_pretty`
- `__bpp_theme_minimalistic`
- `__bpp_theme_involved`

`__bpp_setup_theme` dispatches to one of these functions based on `BPP_THEME`.

This design keeps:

- **layout logic** in the runtime file;
- **styling tokens** in [globals.sh](../globals.sh);
- **selection and persistence** in [cli/cli.sh](../cli/cli.sh).

### Git integration

Git-aware behavior is intentionally lightweight and shell-native:

- `git remote` / `git remote -v` detect whether the repository exists and infer a hosting icon;
- `git rev-parse --abbrev-ref HEAD` gets the current ref;
- `git status --porcelain` marks the prompt as dirty when there are uncommitted changes.

All Git calls are best-effort and suppress stderr so the prompt remains quiet outside repositories.

### Portability considerations

The project includes a few design choices specifically for cross-platform shell behavior:

- the launcher resolves symlinks before locating package files;
- the launcher can recover from npm layouts where `bin` and package files are separated;
- in-place file editing is implemented without relying on GNU-only `sed -i` behavior;
- prompt activation is based on `source` and Bash built-ins rather than external daemons or compiled binaries.

### Why the project is structured this way

This architecture optimizes for:

- **simple installation** through npm;
- **native Bash runtime** with no Node.js process kept alive;
- **live reconfiguration** inside the current terminal session;
- **portable shell behavior** across Linux, macOS, and Git Bash-like environments;
- **small, separated responsibilities** between bootstrap, CLI, runtime, and defaults.

## Development guide

This section is for contributors working on the repository source code.

### Repository layout

- [cli/](../cli/) - launcher and CLI implementation
- [pretty-prompt.sh](../pretty-prompt.sh) - prompt runtime entrypoint
- [globals.sh](../globals.sh) - defaults, presets, and exported styling variables
- [example.env.sh](../example.env.sh) - template for user configuration
- [docs/](../docs/) - project documentation

### Recommended VS Code extensions

- [Bash IDE](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)
- [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

### Tooling

- [Prettier](https://prettier.io/docs/install) - Markdown, JSON, and shell formatting
- [CSpell](https://cspell.org/docs/installation) - spell checking

### Local development

To run from a local clone:

```bash
bash ./cli/bpp setup
```

Then open a new shell session:

```bash
bash
```
