eval `dbus-launch --sh-syntax`
/home/raef/.scripts/layout-roaming

xset s off
xset -dpms
xset s noblank

#[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
#xrandr --dpi 196

#export GDK_SCALE=2
#gsettings set org.gnome.desktop.interface scaling-factor 2
export BROWSER=/usr/bin/firefox
mount ~/Media
i3 --shmlog-size=26214400
