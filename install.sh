#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="$HOME/.config/codex-dotfiles"

append_once() {
  local path="$1"
  local marker="$2"
  local snippet="$3"

  touch "$path"
  if ! grep -Fq "$marker" "$path"; then
    printf "\n%s\n" "$snippet" >> "$path"
  fi
}

install -d "$HOME/.local/bin"
install -m 0755 "$repo_dir/bin/tmux-codex-layout" "$HOME/.local/bin/tmux-codex-layout"
install -m 0755 "$repo_dir/bin/tmux-codex-open-edits" "$HOME/.local/bin/tmux-codex-open-edits"
install -m 0755 "$repo_dir/bin/ai-worktree-create" "$HOME/.local/bin/ai-worktree-create"
install -m 0755 "$repo_dir/bin/ai-todo-worktrees" "$HOME/.local/bin/ai-todo-worktrees"
install -m 0755 "$repo_dir/bin/tmux-opencode-popup" "$HOME/.local/bin/tmux-opencode-popup"
install -m 0755 "$repo_dir/bin/tmux-ai-prs-popup" "$HOME/.local/bin/tmux-ai-prs-popup"
install -m 0755 "$repo_dir/bin/ai-pr-dashboard" "$HOME/.local/bin/ai-pr-dashboard"

install -d "$config_dir"
install -m 0644 "$repo_dir/modules/tmux/tmux.conf" "$config_dir/tmux.conf"
install -m 0644 "$repo_dir/modules/vim/vimrc" "$config_dir/vimrc"
install -m 0644 "$repo_dir/modules/bash/codex-tmux.bash" "$config_dir/codex-tmux.bash"

tmux_snippet='
# >>> codex tmux config >>>
source-file "$HOME/.config/codex-dotfiles/tmux.conf"
# <<< codex tmux config <<<
'

vim_snippet='
" >>> codex vim config >>>
if filereadable(expand("$HOME/.config/codex-dotfiles/vimrc"))
  source $HOME/.config/codex-dotfiles/vimrc
endif
" <<< codex vim config <<<
'

bash_snippet='
# >>> codex tmux/bash flow >>>
if [ -f "$HOME/.config/codex-dotfiles/codex-tmux.bash" ]; then
  . "$HOME/.config/codex-dotfiles/codex-tmux.bash"
fi
# <<< codex tmux/bash flow <<<
'

append_once "$HOME/.tmux.conf" "codex tmux config" "$tmux_snippet"
append_once "$HOME/.vimrc" "codex vim config" "$vim_snippet"
append_once "$HOME/.bashrc" "codex tmux/bash flow" "$bash_snippet"

printf "Installed helper scripts and additively sourced tmux, Vim, and Bash config.\n"
printf "Restart your shell, then run: tmux\n"
