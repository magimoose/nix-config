#!/usr/bin/env bash
LAPTOP_MONITOR="eDP-1"

move_workspaces() {
  # Find external monitor (any monitor that isn't the laptop)
  EXTERNAL=$(hyprctl monitors -j | jq -r '.[].name' | grep -v "$LAPTOP_MONITOR" | head -1)

  if [ -z "$EXTERNAL" ]; then
    return
  fi

  for i in $(seq 2 10); do
    hyprctl dispatch moveworkspacetomonitor "$i $EXTERNAL"
  done
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  case $line in
    monitoradded*)
      sleep 1
      move_workspaces
      ;;
  esac
done
