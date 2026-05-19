# Bash integration for the tmux AI development layout.
# Source this from ~/.bashrc after tmux is installed.

set -o vi
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"

__codex_tmux_available() {
  [[ -n "${TMUX:-}" ]] && command -v tmux >/dev/null 2>&1
}

__codex_tmux_split_horizontal() {
  __codex_tmux_available && tmux split-window -v -c "#{pane_current_path}"
}

__codex_tmux_split_vertical() {
  __codex_tmux_available && tmux split-window -h -c "#{pane_current_path}"
}

__codex_tmux_new_window() {
  __codex_tmux_available && tmux new-window -c "#{pane_current_path}"
}

__codex_tmux_cycle_pane() {
  __codex_tmux_available && tmux select-pane -t :.+
}

if [[ $- == *i* ]]; then
  bind -m vi-command -x '"ss":__codex_tmux_split_horizontal'
  bind -m vi-command -x '"sv":__codex_tmux_split_vertical'
  bind -m vi-command -x '"te":__codex_tmux_new_window'
  bind -m vi-command -x '" ":__codex_tmux_cycle_pane'
fi
