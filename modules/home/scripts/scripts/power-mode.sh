#!/usr/bin/env bash

# Power mode toggle for Hyprland — saves GPU power on battery
# Usage: power-mode [battery|ac|toggle|auto]

STATE_FILE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/power-mode-state"

set_battery() {
    hyprctl keyword decoration:blur:enabled false > /dev/null
    echo "battery" > "$STATE_FILE"
    pkill -RTMIN+8 waybar || true
    notify-send -u low "Power Mode" "Battery — blur disabled"
}

set_ac() {
    hyprctl keyword decoration:blur:enabled true > /dev/null
    echo "ac" > "$STATE_FILE"
    pkill -RTMIN+8 waybar || true
    notify-send -u low "Power Mode" "AC — blur restored"
}

get_current() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "ac"
    fi
}

detect_power_source() {
    for supply in /sys/class/power_supply/*/; do
        if [ -f "${supply}type" ] && [ "$(cat "${supply}type")" = "Mains" ]; then
            if [ -f "${supply}online" ] && [ "$(cat "${supply}online")" = "1" ]; then
                echo "ac"
                return
            fi
        fi
    done
    echo "battery"
}

case "${1:-auto}" in
    battery)
        set_battery
        ;;
    ac)
        set_ac
        ;;
    toggle)
        if [ "$(get_current)" = "ac" ]; then
            set_battery
        else
            set_ac
        fi
        ;;
    auto)
        source="$(detect_power_source)"
        if [ "$source" = "ac" ]; then
            set_ac
        else
            set_battery
        fi
        ;;
    *)
        echo "Usage: power-mode [battery|ac|toggle|auto]"
        exit 1
        ;;
esac
