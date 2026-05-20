# Agent Worktree Orchestration

When the user gives you a todo file and asks to work with Git worktrees, use this workflow.

1. Read the todo file, usually `~/todo.md`, and identify independent work items.
2. Group items into the fewest safe worktrees:
   - Combine items that touch the same subsystem, share tests, or require the same context.
   - Split items that can be implemented independently or are likely to conflict.
   - Do not create a separate worktree for every line unless that is actually efficient.
3. For each group, create a titled tmux window and worktree with `ai-worktree-create`.
4. Use concise task names because they become branch names, directory names, and tmux window titles.
5. Start the requested agent command in the new window when appropriate.

Preferred command shape:

```bash
ai-worktree-create \
  --repo <repo-path> \
  --todo "$HOME/todo.md" \
  --task "<short grouped task description>" \
  --opencode
```

Use `--opencode` for OpenCode. This starts OpenCode in the worktree and passes the todo/task through `--prompt`; do not pass the todo file as `opencode $HOME/todo.md`, because this OpenCode CLI treats the positional argument as a project directory. Use `--command "codex"` for Codex or `--command "claude"` for Claude Code. If the user only asks to prepare worktrees, omit `--command` and `--opencode`.

The script symlinks untracked and ignored local files into each worktree. Do not manually copy dependency folders, environment files, caches, or generated local assets unless the script reports that a specific path could not be linked.

Creating the worktree creates a Git branch and updates `.git/refs`. If sandboxing reports `.git` as read-only, rerun the same `ai-worktree-create` command with the required approval/escalation instead of changing the workflow.

Before opening parallel windows, state the grouping plan briefly. After creation, report each tmux window title, worktree path, and task group.

For a user-facing one-command flow, tell the user to edit `~/todo.md` with unchecked `- [ ]` tasks and run `ai-todo-worktrees` from the repo root inside tmux. That command creates one OpenCode-backed worktree window per unchecked task in the current tmux session. Use the lower-level `ai-worktree-create` workflow above when an agent should group related todo items before creating worktrees.
