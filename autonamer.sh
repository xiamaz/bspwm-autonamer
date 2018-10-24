#!/bin/dash

# Set the desktop name based on the activating window class
# Args:
# 1 window class
# 2 window id (used for some title lookups)
set_name() {
	case $1 in
		Firefox)
			name="Firefox"
			;;
		Thunderbird)
			name="Mail"
			;;
		Nautilus)
			name="Files"
			;;
		st-256color)
			name="Terminal"
			title=$(xprop -id $2 _NET_WM_NAME | grep -Po '(?<= = ")[^"]+')
			case "$title" in
				st-main-home-tmux)
					name="Thinkstation-D20"
					;;
				st-main-local-tmux)
					name="$(hostname)"
					;;
				st-ssh-*)
					name="$(echo $title | grep -Po '(?<=st-ssh-).+')"
					;;
			esac
			;;
		keepassxc)
			bspc desktop ^5 -f
			name="Keepass"
			;;
		Remmina)
			name="RDP"
			;;
		Chromium)
			name="Chromium"
			;;
		*)
			echo "Class $1 not found" > /tmp/bspc-external-rename
			return
			;;
	esac
	bspc desktop -n $name
}

wid=$1
class=$(echo ${2} | xargs)
instance=$(echo ${3} | xargs)
# title=$(xtitle "$wid")

# Debug
# echo "$wid $class $instance" > /tmp/bspc-external-rules

# name the desktop if it doesnt already have a name
desktop_name=$(bspc query -D -d --names)
case $desktop_name in
	[0-9]*)
		echo "Empty, rename." > /tmp/bspc-external-rename
		set_name $class $wid
		;;
	*)
		echo "Full, do not rename." > /tmp/bspc-external-rename
		;;
esac
