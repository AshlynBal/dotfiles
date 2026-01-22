#!/bin/bash
DEVICE_BATTERY="/org/freedesktop/UPower/devices/battery_BAT0"
DISCHARGING_ICONS=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
CHARGING_ICONS=("󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")


BATTERY_STATE=$(upower -i $DEVICE_BATTERY)

function get_property() {
    local LINE=$(echo "$BATTERY_STATE" | grep -o "$1:[[:space:]]*.*" | cut -f2 -d ":")
    if [ -z "$LINE" ]; then
        return 1
    fi
    # This intentionally has no quotation marks to remove the unnecessary space.
    echo $LINE
    return 0
}

# Gets an element from the array depending on the value of percent.
# The percentages are mapped to the arrays equally, with the exception of the first and last,
# each of which having half the "space".
function get_from_list() {
    local PERCENT=$1
    local -n LIST="$2"
    local LIST_LEN="${#LIST[@]}"
    local INDEX="$(( ( (LIST_LEN - 1) * PERCENT + 50 ) / 100 ))"
    echo "${LIST[INDEX]}"
}

function get_battery_from_list() {
    local PERCENT=$1
    local -n LIST="$2"
    local LIST_LEN="${#LIST[@]}"
    if [ "$PERCENT" -le "$((50 / LIST_LEN))" ]; then
        echo "${LIST[0]}"
        return 0
    fi
    local INDEX="$(( ( (LIST_LEN - 1) * PERCENT) / 100 + 1))"
    echo "${LIST[INDEX]}"
    return 0
}
# Echoes an icon, depending on the state of the battery, and on the percentage.
function get_icon() {
    local STATE=$1
    local PERCENT=$2
#     echo "Local State: $STATE"
#     echo "Local Percent: $PERCENT"

    case "$STATE" in
        discharging )
            echo $(get_from_list "$PERCENT" DISCHARGING_ICONS) ;;
        pending-charge | fully-charged )
            echo "" ;;
        charging )
            echo $(get_from_list "$PERCENT" CHARGING_ICONS) ;;
        * )
            echo "X" ;;
    esac
}

function format_time() {
    local RAW_TIME=$1
    local MULTIPLIER=1
    local MINUTES=0
    local HOURS=0
    if echo $RAW_TIME | grep -q "minutes"; then
        MULTIPLIER=1
    elif echo $RAW_TIME | grep -q "hours"; then
        MULTIPLIER=60
    elif echo $RAW_TIME | grep -q "days"; then
        MULTIPLIER=1440
    fi
    UNFORMATTED_TIME=$(echo $RAW_TIME | cut -f1 -d " ")
#     echo "$UNFORMATTED_TIME"
#     echo "Multiplier: $MULTIPLIER"
    local TOTAL_MINUTES="$(echo "$UNFORMATTED_TIME * $MULTIPLIER" | bc | cut -f1 -d '.')"
#     echo "Total minutes: $TOTAL_MINUTES"
    echo "$(( TOTAL_MINUTES / 60 )) h $(( TOTAL_MINUTES % 60 )) min"
}

# Returns a string dependant on the battery state and time to empty / full
function get_time() {
    local STATE="$1"
    local TIME_TO_EMPTY="$2"
    local TIME_TO_FULL="$3"

    local TEXT=""
    local RAW_TIME=""
    if [ -n "$TIME_TO_EMPTY" ]; then
        RAW_TIME="$TIME_TO_EMPTY"
        TEXT="Empty in"
    elif [ -n "$TIME_TO_FULL" ]; then
        RAW_TIME="$TIME_TO_FULL"
        TEXT="Full in"
    else
        case "$STATE" in
            discharging)
                echo "Discharging"
                return 0
                ;;
            pending-charge | fully-charged)
                echo "Plugged"
                return 0
                ;;
            plugged)
                echo "uh, idk, lol"
                return 1
                ;;
        esac
    fi

    local TIME=$(format_time "$RAW_TIME")
    echo "$TEXT $TIME"
}

# echo "$BATTERY_STATE"
# echo "{ \"text\": \"CLASS\",  \"class\": \"class\",  \"percentage\": \"0.5\" }"
STATE=$(get_property "state")
PERCENT=$(get_property "percentage" | grep -o '[[:digit:]]\+')
TIME_TO_EMPTY=$(get_property "time to empty")
TIME_TO_FULL=$(get_property "time to full")
ICON=$(get_icon $STATE $PERCENT)
TIME=$(get_time "$STATE" "$TIME_TO_EMPTY" "$TIME_TO_FULL")
POWER_PROFILE=$(powerprofilesctl get)
# echo "State: $STATE"
# echo "Percent: $PERCENT"
# echo "Time to empty: $TIME_TO_EMPTY"
# echo "Time to full: $TIME_TO_FULL"
# echo "Icon: $ICON"
# echo "Time: $TIME"
# echo "$PERCENT% - $TIME"


TEXT="$ICON $PERCENT%"
TOOLTIP="$PERCENT% - $TIME\nProfile: $POWER_PROFILE"
CLASS=""
ALT=""
echo "{\"text\": \"$TEXT\",\"tooltip\": \"$TOOLTIP\",\"class\": \"\", \"alt\": \"$ALT\"}"
