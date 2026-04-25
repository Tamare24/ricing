#!/bin/bash

# Fungsi untuk cek status baterai
handle() {
  nm=$1
  if [[ ${nm:0:2} == "ac" ]]; then
    if [[ ${nm:3:1} == "1" ]]; then
      powerprofilesctl set performance
      notify-send "Power Source" "Charger Connected: Performance Mode Active" -i ac-adapter
    else
      powerprofilesctl set balanced
      notify-send "Power Source" "Charger Disconnected: Balanced Mode Active" -i battery
    fi
  fi
}

# Monitor event dari system (udev)
udevadm monitor --subsystem-match=power_supply | while read -r line; do
  # Jika ada perubahan status power
  if echo "$line" | grep -q "change"; then
    STATUS=$(cat /sys/class/power_supply/AC/online)
    if [ "$STATUS" -eq 1 ]; then
      powerprofilesctl set performance
      notify-send "Power Source" "Performance Mode"
    else
      powerprofilesctl set balanced
      notify-send "Power Source" "Balanced Mode"
    fi
  fi
done
