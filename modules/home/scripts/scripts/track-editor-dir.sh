#!/usr/bin/env bash
# Listen to Hyprland focus events and track the working directory of editor
# windows (VSCode, kitty+nvim, ghostty+nvim). The directory is persisted to
# a file so other scripts (e.g. terminal-editor-dir) can read it.

EDITOR_DIR_FILE="${XDG_RUNTIME_DIR:-/tmp}/current_editor_dir"

if ! command -v socat >/dev/null 2>&1; then
  echo "socat is required but not installed; aborting" >&2
  exit 1
fi

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
    kitty|com.mitchellh.ghostty)
      if [[ "$title" == nvim\ * ]]; then
        local path="${title#nvim }"
        # Expand leading ~
        path="${path/#\~/$HOME}"
        if [ -d "$path" ]; then
          dir="$path"
        elif [ -f "$path" ]; then
          dir=$(dirname "$path")
        fi
      else
        # For regular terminal windows, read CWD from /proc
        dir=$(readlink -f "/proc/$pid/cwd" 2>/dev/null)
      fi
      ;;
  esac

  if [ -n "$dir" ] && [ -d "$dir" ]; then
    printf '%s\n' "$dir" > "$EDITOR_DIR_FILE"
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
