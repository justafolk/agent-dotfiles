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
- Creates fast per-task Git worktrees for Codex, Claude Code, or OpenCode sessions.

## Keybindings

Tmux:

- `C-w s`: horizontal split
- `C-w v`: vertical split
- `C-w e`: new window
- `C-w h/j/k/l`: move between panes
- `C-w l`: cycle panes
- `C-w C`: start `codex` in the main pane
- `C-w Q`: open a floating OpenCode terminal in the coding agent directory
- `C-w P`: open the shared floating PR dashboard
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

The installer is additive for user config. It writes this repo's tmux, Vim, and
Bash snippets under `~/.config/codex-dotfiles/`, then adds marked `source`
blocks to `~/.tmux.conf`, `~/.vimrc`, and `~/.bashrc` if they are not already
present. Existing user config is not replaced.

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
- `bin/ai-worktree-create`: per-task worktree creator with tmux window support.
- `bin/ai-todo-worktrees`: friendly `~/todo.md` launcher for tmux worktree sessions.
- `bin/tmux-opencode-popup`: floating OpenCode quick-question popup.
- `bin/tmux-ai-prs-popup`: shared tmux popup wrapper for the PR dashboard.
- `bin/ai-pr-dashboard`: dynamic `gh`-powered dashboard for worktree PRs.
- `home/`: exact copies of the files from the original machine.

## Agent Worktrees

Write task items in `~/todo.md`:

```markdown
- [ ] fix auth redirect and add regression test
- [ ] update dashboard empty state
```

Then run this from inside tmux at the repo root:

```bash
ai-todo-worktrees
```

That reads unchecked `- [ ]` items from `~/todo.md`, creates one Git worktree
per item, and adds OpenCode windows to the current tmux session. Each window
uses the standard three-pane layout: the agent on the left, a shell on the
right, and Vim below it watching files changed by that agent. Use
`ai-todo-worktrees --dry-run` to preview the detected tasks.

For manual control, create one titled tmux window per worktree with:

```bash
ai-worktree-create \
  --repo . \
  --todo "$HOME/todo.md" \
  --task "fix auth redirect and add regression test" \
  --opencode
```

The script creates `../<repo>-worktrees/<task>-<timestamp>`, starts a new
`agent/<task>-<timestamp>` branch, and symlinks local untracked plus ignored
files from the source worktree. This keeps expensive local state such as
`.env`, dependency folders, caches, and generated assets available without
copying them into every worktree.

`--opencode` starts OpenCode in the new worktree and passes the todo file plus
task through `--prompt`. For other tools, use `--command "codex"` or
`--command "claude"`. Commands are sent into a persistent shell-backed tmux
window, so the window remains available for inspection even if the agent command
exits immediately.

## Notes

The watcher is agent-agnostic. It works with Codex, Claude Code, OpenCode, or any tool that edits files on disk under the watched path. It tracks changed files, not editor identity.

By default, the watcher uses the main pane's current directory or Git repo root. To force a broader root:

```bash
tmux set-option -g @codex_watch_root "$HOME/projects"
```

To make that permanent, edit `modules/tmux/tmux.conf`.

The PR dashboard uses `gh` and `jq`. It opens in a shared `ai-prs` tmux session,
so `C-w P` from any window shows the same live view. It polls GitHub every 30
seconds by default; override that with `AI_PR_DASHBOARD_INTERVAL`.
