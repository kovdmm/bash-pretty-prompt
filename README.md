# @kovdmm/bpp (bash-pretty-prompt)

[![image](https://github.com/user-attachments/assets/b50805e8-4225-4a19-8030-892966afe09a)](#bash-pretty-prompt)

Git-aware Bash prompt with 24-bit colors, Nerd Fonts, and multiple themes.

## Installation (npm)

```bash
npm install --global @kovdmm/bpp
bpp setup
```

The `setup` command:

- creates `env.sh` from `example.env.sh` (if needed);
- adds prompt integration to `~/.bashrc`;
- updates the path automatically if package location changes;
- resolves the installed package directory even when the `bpp` executable lives in a separate global `bin` directory (for example on macOS).

After setup, start a new shell session:

```bash
bash
```

## Configuration

The prompt is configured via `env.sh` in the installed package directory.

You can either edit `env.sh` directly or use CLI commands:

```bash
bpp theme involved
bpp icons nerd_font
bpp separators powerline
bpp status enable
```

Available values:

- `theme`: `simple`, `pretty`, `minimalistic`, `involved`
- `icons`: `nerd_font`, `emoji`, `none`
- `separators`: `powerline`, `unicode`, `none`
- `status`: `enable`, `disable`

## CLI

```bash
bpp setup
bpp theme <theme-name>
bpp icons <preset>
bpp separators <preset>
bpp status <enable|disable>
bpp help
```

## Requirements

- Bash shell
- Node.js + npm
- Optional: [Nerd Font](https://www.nerdfonts.com/) for icon rendering

## For Contributors

Contributor and architecture docs are in [docs/README.md](docs/README.md).
