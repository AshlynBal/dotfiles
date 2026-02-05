function get_device() {
    device_name="$1"
    device_line="$(libinput list-kernel-devices | grep -m 1 "$device_name")"
    echo "$device_line" | grep -o "/dev/input/event[0-9]*"
}

event_keyboard=$(get_device "keyboard")
event_mouse="$(get_device "Touchpad")"

evsieve --input "$event_keyboard" \
        --input "$event_mouse" grab domain=mouse \
        --map key:left:1~2      rel:x:-20@mouse \
        --map key:right:1~2     rel:x:20@mouse  \
        --map key:up:1~2        rel:y:-20@mouse \
        --map key:down:1~2      rel:y:20@mouse  \
        --map key:enter:0~1     btn:left@mouse  \
        --map key:backslash:0~1 btn:right@mouse \
        --output @mouse
