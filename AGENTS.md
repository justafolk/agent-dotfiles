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
  --command "opencode $HOME/todo.md"
```

Use `--command "codex"` for Codex, `--command "claude"` for Claude Code, or `--command "opencode $HOME/todo.md"` for OpenCode. If the user only asks to prepare worktrees, omit `--command`.

The script symlinks untracked and ignored local files into each worktree. Do not manually copy dependency folders, environment files, caches, or generated local assets unless the script reports that a specific path could not be linked.

Before opening parallel windows, state the grouping plan briefly. After creation, report each tmux window title, worktree path, and task group.
