#!/usr/bin/env bash
# Listen to Hyprland focus events and track the working directory of the
# focused window. The directory is persisted to a file so other scripts
# (e.g. terminal-editor-dir) can read it.

EDITOR_DIR_FILE="${XDG_RUNTIME_DIR:-/tmp}/current_editor_dir"

if ! command -v socat >/dev/null 2>&1; then
  echo "socat is required but not installed; aborting" >&2
  exit 1
fi

# Walk /proc to find the deepest child of a given PID and return its cwd.
deepest_child_cwd() {
  local pid="$1" child
  # Follow the chain of children to the leaf process (the actual shell/program)
  while true; do
    child=$(pgrep -P "$pid" --oldest 2>/dev/null | head -1)
    [ -n "$child" ] || break
    pid="$child"
  done
  readlink -f "/proc/$pid/cwd" 2>/dev/null
}

track_editor_dir() {
  local win_info class title pid dir=""
  win_info=$(hyprctl activewindow -j 2>/dev/null) || return

  class=$(printf '%s' "$win_info" | jq -r '.class')
  title=$(printf '%s' "$win_info" | jq -r '.title')
  pid=$(printf '%s' "$win_info" | jq -r '.pid')

  case "$class" in
    code|code-url-handler)
      # VSCode: multiple windows share the same pid, so /proc/$pid/cwd is
      # unreliable. Extract the project name from the title instead.
      # Title format: "filename - project-name - Visual Studio Code"
      local project_name
      project_name=$(printf '%s' "$title" | awk -F ' - ' '{print $(NF-1)}')
      for base in "$HOME" "$HOME/Projects" "$HOME/Documents"; do
        if [ -d "$base/$project_name" ]; then
          dir="$base/$project_name"
          break
        fi
      done
      ;;
    kitty)
      # Use kitty's remote control to get the focused window's foreground
      # process cwd. This correctly handles multiple tabs/windows.
      local socket="/tmp/kitty-${pid}"
      if [ -S "$socket" ]; then
        dir=$(kitty @ --to "unix:$socket" ls 2>/dev/null | jq -r '
          .[].tabs[] | select(.is_focused) | .windows[] | select(.is_focused) |
          .foreground_processes[0].cwd
        ')
      fi
      ;;
    *)
      # For any window, find the deepest child process and read its cwd.
      dir=$(deepest_child_cwd "$pid")
      ;;
  esac

  if [ -n "$dir" ] && [ -d "$dir" ]; then
    printf '%s\n' "$dir" > "$EDITOR_DIR_FILE"
    pkill -RTMIN+9 waybar 2>/dev/null
  fi
}

handle() {
  case "$1" in
    activewindowv2*)
      track_editor_dir
      ;;
  esac
}

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
  while read -r line; do
    handle "$line"
  done
