function get_device() {
    device_name="$1"
    device_line="$(libinput list-kernel-devices | grep -m 1 "$device_name")"
    echo "$device_line" | grep -o "/dev/input/event[0-9]*"
}

function get_device_by_path() {
    device_name="$1"
#     ls ""
}

dev_file="$(get_device "Pro Controller")"
mouse_file="/dev/input/by-path/pci-0000:00:15.3-platform-i2c_designware.2-event-mouse"

evsieve --input "$dev_file"                         \
        --input "$mouse_file" grab domain=mouse     \
    --copy btn:mode             key:leftmeta@kb     \
                                                    \
    `# Directional pad`                             \
    --copy abs:hat0x:-1         key:left:1@kb       \
    --copy abs:hat0x:-1..0~     key:left:0@kb       \
    --copy abs:hat0x:1          key:right:1@kb      \
    --copy abs:hat0x:1..~0      key:right:0@kb      \
    --copy abs:hat0y:-1         key:up:1@kb         \
    --copy abs:hat0y:-1..0~     key:up:0@kb         \
    --copy abs:hat0y:1          key:down:1@kb       \
    --copy abs:hat0y:1..~0      key:down:0@kb       \
                                                    \
    `# Triggers`                                    \
    --map btn:tl2               btn:left@mouse      \
    --map btn:tr2               btn:right@mouse     \
    `# Joystick`                                    \
                                                    \
                                                    \
                                                    \
                                                    \
        --map key:left:1~2      rel:x:-20@mouse \
        --map key:right:1~2     rel:x:20@mouse  \
        --map key:up:1~2        rel:y:-20@mouse \
        --map key:down:1~2      rel:y:20@mouse  \
        --map key:enter:0~1     btn:left@mouse  \
                                                    \
    --output @kb repeat                             \
    --output @mouse
