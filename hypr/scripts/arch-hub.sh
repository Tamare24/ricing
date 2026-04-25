#!/bin/bash

# Konfigurasi Wofi
WOFI="wofi --dmenu --width 400 --height 450 --style $HOME/.config/hypr/wofi/style.css --cache-file /dev/null"

# List Menu Utama
OPTIONS="🚀 Applications\n🔋 Power Mode\n⌨️ Keyboard Light\n🖼️ Change Wallpaper\n🌙 Night Shift\n🔄 Sync to GitHub\n⚙️ System Settings\n🛑 Power Menuu\n🔋 Battery Health"

CHOICE=$(echo -e "$OPTIONS" | $WOFI --prompt "Arch Command Center")

case $CHOICE in
    "🚀 Applications")
        wofi --show drun
        ;;
    "🔋 Power Mode")
        POWER_OPT="Performance\nBalanced\nPower Saver"
        P_CHOICE=$(echo -e "$POWER_OPT" | $WOFI --prompt "Select Power Profile")
        case $P_CHOICE in
            "Performance") powerprofilesctl set performance && notify-send "System" "Mode: Performance Active" -i status_caps ;;
            "Balanced") powerprofilesctl set balanced && notify-send "System" "Mode: Balanced Active" -i status_caps ;;
            "Power Saver") powerprofilesctl set power-saver && notify-send "System" "Mode: Power Saver Active" -i status_caps ;;
        esac
        ;;
    "⌨️ Keyboard Light")
        KBD_OPT="Off\nLow (50%)\nHigh (100%)"
        K_CHOICE=$(echo -e "$KBD_OPT" | $WOFI --prompt "Keyboard Backlight")
        case $K_CHOICE in
            "Off") brightnessctl --device='dell::kbd_backlight' set 0 ;;
            "Low (50%)") brightnessctl --device='dell::kbd_backlight' set 1 ;; # Sesuaikan angka 1/2 tergantung laptop
            "High (100%)") brightnessctl --device='dell::kbd_backlight' set 2 ;;
        esac
        ;;
    "🖼️ Change Wallpaper")
        # Pilih file dari folder Pictures
        WALL=$(ls ~/Pictures/*.{jpg,png,jpeg} | $WOFI --prompt "Select Wallpaper")
        if [ -n "$WALL" ]; then
            killall swaybg
            swaybg -i "$WALL" -m fill &
            notify-send "Wallpaper" "Wallpaper Updated!"
        fi
        ;;
    "🌙 Night Shift")
        # Menggunakan gammastep (pastikan sudah instal: sudo apt install gammastep)
        if pgrep -x "gammastep" > /dev/null; then
            killall gammastep && notify-send "Night Shift" "Eye Protection Disabled"
        else
            gammastep -O 3500 & notify-send "Night Shift" "Eye Protection Active"
        fi
        ;;
    "🔄 Sync to GitHub")
        notify-send "GitHub" "Backing up dotfiles..."
        cd ~/dotfiles && ./sync.sh && git add . && git commit -m "Auto-sync from Arch Hub" && git push && notify-send "GitHub" "Sync Success!"
        ;;
    "⚙️ System Settings")
        nm-connection-editor & blueman-manager & pavucontrol
        ;;
    "🛑 Power Menu")
        P_MENU="Logout\nReboot\nShutdown"
        P_RES=$(echo -e "$P_MENU" | $WOFI --prompt "Power Operations")
        case $P_RES in
            "Logout") hyprctl dispatch exit ;;
            "Reboot") reboot ;;
            "Shutdown") shutdown now ;;
        esac
        ;;
     "🔋 Battery Health")
        B_OPT="Stationary (Stop at 80%)\nFull Charge (100%)"
        B_CHOICE=$(echo -e "$B_OPT" | $WOFI --prompt "Battery Health")
        case $B_CHOICE in
            "Stationary (Stop at 80%)") 
                sudo bash -c "echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold"
                notify-send "Battery" "Threshold set to 80% (Stationary Mode)" ;;
            "Full Charge (100%)") 
                sudo bash -c "echo 100 > /sys/class/power_supply/BAT0/charge_control_end_threshold"
                notify-send "Battery" "Threshold set to 100% (Full Capacity)" ;;
        esac
        ;;
esac
