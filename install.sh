#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

backup_file() {
  local path="$1"
  if [[ -e "$path" && ! -L "$path" ]]; then
    cp "$path" "$path.backup.$(date +%Y%m%d%H%M%S)"
  fi
}

install -d "$HOME/.local/bin"
install -m 0755 "$repo_dir/bin/tmux-codex-layout" "$HOME/.local/bin/tmux-codex-layout"
install -m 0755 "$repo_dir/bin/tmux-codex-open-edits" "$HOME/.local/bin/tmux-codex-open-edits"
install -m 0755 "$repo_dir/bin/ai-worktree-create" "$HOME/.local/bin/ai-worktree-create"
install -m 0755 "$repo_dir/bin/tmux-opencode-popup" "$HOME/.local/bin/tmux-opencode-popup"
install -m 0755 "$repo_dir/bin/tmux-ai-prs-popup" "$HOME/.local/bin/tmux-ai-prs-popup"
install -m 0755 "$repo_dir/bin/ai-pr-dashboard" "$HOME/.local/bin/ai-pr-dashboard"

backup_file "$HOME/.tmux.conf"
backup_file "$HOME/.vimrc"
cp "$repo_dir/modules/tmux/tmux.conf" "$HOME/.tmux.conf"
cp "$repo_dir/modules/vim/vimrc" "$HOME/.vimrc"

bash_snippet='
# >>> codex tmux/bash flow >>>
if [ -f "$HOME/.config/codex-dotfiles/codex-tmux.bash" ]; then
  . "$HOME/.config/codex-dotfiles/codex-tmux.bash"
fi
# <<< codex tmux/bash flow <<<
'

install -d "$HOME/.config/codex-dotfiles"
cp "$repo_dir/modules/bash/codex-tmux.bash" "$HOME/.config/codex-dotfiles/codex-tmux.bash"

if [[ -f "$HOME/.bashrc" ]] && ! grep -q 'codex tmux/bash flow' "$HOME/.bashrc"; then
  printf "%s\n" "$bash_snippet" >> "$HOME/.bashrc"
fi

printf "Installed tmux, Vim, Bash, worktree, PR dashboard, and helper script config.\n"
printf "Restart your shell, then run: tmux\n"
