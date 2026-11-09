# dotfiles

[![ci](https://github.com/OWNER/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/OWNER/dotfiles/actions/workflows/ci.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![shell: zsh](https://img.shields.io/badge/shell-zsh-89e051)
![editor: neovim](https://img.shields.io/badge/editor-neovim-57A143)

Personal configuration for zsh, git, tmux, neovim and Homebrew.

## Install

```sh
git clone https://github.com/OWNER/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --dry-run   # see what will change
./install.sh             # link everything
```

Existing files are moved to `~/.dotfiles-backup/<timestamp>/` before a link
replaces them. Running the script again is safe: links that are already in
place are skipped.

On a new Mac, `./install.sh --brew` also installs everything in
[`brew/Brewfile`](brew/Brewfile).

## What gets linked

| Source | Target |
| --- | --- |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zshenv` | `~/.zshenv` |
| `git/gitconfig` | `~/.gitconfig` |
| `git/gitignore_global` | `~/.config/git/ignore` |
| `git/gitmessage` | `~/.config/git/message` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `nvim/` | `~/.config/nvim` |

## Machine-local settings

Things that differ between machines stay out of the repo:

- `~/.gitconfig.local` holds `user.name` and `user.email`. The installer writes
  it from `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` or asks for them. See
  [`git/gitconfig.local.example`](git/gitconfig.local.example).
- `~/.zshrc.local` is sourced last, for work-only aliases, tokens and paths.

## Neovim

Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim), which
bootstraps itself on first launch. Language support:

| Language | LSP | Formatter |
| --- | --- | --- |
| TypeScript / JavaScript | vtsls | prettierd / prettier |
| Python | basedpyright + ruff | ruff |
| Rust | rust-analyzer (rustaceanvim) | rustfmt |
| Lua | lua_ls | stylua |

LSP servers are installed by mason on first use. `rust-analyzer` comes from
rustup: `rustup component add rust-analyzer`.

Leader is `<space>`. Press it and wait for which-key to show the groups.

## Development

```sh
make test   # install into a temp HOME and check every config loads
make lint   # shellcheck + stylua --check
make fmt    # format lua
```

Tests are plain bash with no dependencies beyond zsh, tmux and git. Each test
gets a fresh temporary `$HOME`, so they never touch your real files.

## Keybindings worth knowing

| Where | Keys | Does |
| --- | --- | --- |
| zsh | `Ctrl-Space` | accept autosuggestion |
| zsh | `Ctrl-X Ctrl-E` | edit command in `$EDITOR` |
| zsh | `Ctrl-R` / `Ctrl-T` | fzf history / file search |
| tmux | `Ctrl-A` | prefix |
| tmux | `prefix \|` / `prefix -` | split right / below in current dir |
| tmux | `prefix g` | lazygit popup |
| tmux | `Alt-h` / `Alt-l` | previous / next window |
| nvim | `<space><space>` | find files |
| nvim | `<space>fg` | live grep |
| nvim | `-` | open parent directory (oil) |
| nvim | `<space>cf` | format buffer |

## License

[MIT](LICENSE)
