# Agent Dotfiles

Tmux, Bash, and Vim setup for terminal-first AI coding with Codex, Claude Code, or OpenCode.

## What It Does

- Uses `C-w` as the tmux prefix.
- Starts a three-pane tmux workspace:
  - left full-height pane for the AI coding agent
  - right-top shell pane
  - right-bottom Vim pane
- Adds Bash vi mode with tmux actions from readline command mode:
  - `ss` splits top/bottom
  - `sv` splits left/right
  - `te` opens a new tmux window
  - `Space` cycles panes
- Watches files edited under the agent pane path and opens/reloads them in Vim tabs.
- Uses `vim-gitgutter` for Git diff signs and hunk navigation.

## Keybindings

Tmux:

- `C-w s`: horizontal split
- `C-w v`: vertical split
- `C-w e`: new window
- `C-w h/j/k/l`: move between panes
- `C-w l`: cycle panes
- `C-w C`: start `codex` in the main pane
- `C-w D`: apply the three-pane layout manually
- `C-w O`: scan changed files and open them in Vim
- `C-w C-w`: send literal `Ctrl-w`

Vim:

- `Tab`: next tab
- `Ctrl-n`: next Git hunk
- `Ctrl-p`: previous Git hunk
- `ss`: split
- `sv`: vertical split
- `te`: new tab
- `Space`: next Vim window

## Install

```bash
git clone <your-repo-url> codex-dotfiles
cd codex-dotfiles
./install.sh
```

Then restart your shell and run:

```bash
tmux
```

Inside Vim, install plugins with:

```vim
:PlugInstall
```

This repo assumes `vim-plug`, `tmux`, `vim`, `git`, and `bash`.

## Repository Layout

- `modules/tmux/tmux.conf`: public tmux config.
- `modules/vim/vimrc`: public Vim config.
- `modules/bash/codex-tmux.bash`: Bash vi-mode tmux integration.
- `bin/tmux-codex-layout`: tmux workspace layout helper.
- `bin/tmux-codex-open-edits`: file watcher that opens changed files in Vim tabs.
- `home/`: exact copies of the files from the original machine.

## Notes

The watcher is agent-agnostic. It works with Codex, Claude Code, OpenCode, or any tool that edits files on disk under the watched path. It tracks changed files, not editor identity.

By default, the watcher uses the main pane's current directory or Git repo root. To force a broader root:

```bash
tmux set-option -g @codex_watch_root "$HOME/projects"
```

To make that permanent, edit `modules/tmux/tmux.conf`.
