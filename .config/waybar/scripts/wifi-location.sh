#!/usr/bin/env bash
HOME_SSID="dom1"
DORM_SSID="MyOptimum ec1dcf"
CLASS_SSID="RUWireless Secure"

SSID="$(nmcli -t -f ACTIVE,TYPE,NAME connection show --active 2>/dev/null \
  | awk -F: '$1=="yes" && $2=="802-11-wireless" {print $3; exit}')"

SIGNAL="$(nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null \
  | awk -F: '$1=="*" {print $2; exit}')"
[[ -z "$SIGNAL" ]] && SIGNAL="?"

if [[ -z "$SSID" ]]; then
  echo "{\"text\":\"OFFLINE\",\"class\":\"offline\"}"
elif [[ "$SSID" == "$HOME_SSID" ]]; then
  echo "{\"text\":\"HOME\",\"class\":\"home\"}"
elif [[ "$SSID" == "$DORM_SSID" ]]; then
  echo "{\"text\":\"DORM\",\"class\":\"dorm\"}"
elif [[ "$SSID" == "$CLASS_SSID" ]]; then
  echo "{\"text\":\"CLASS\",\"class\":\"class\"}"
else
  echo "{\"text\":\"AWAY\",\"class\":\"away\"}"
fi
