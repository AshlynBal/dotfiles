location="$1"
command="$2"

hyprctl dispatch exec [workspace "$location"] "$command"
