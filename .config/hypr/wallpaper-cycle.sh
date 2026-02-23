#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/hyprpaper_wallpaper"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
hyprctl hyprpaper wallpaper ",$WALLPAPER"   
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper "eDP-1,$WALLPAPER"

sleep 1

hyprctl hyprpaper unload unused
