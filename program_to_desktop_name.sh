#!/bin/dash

# Set the desktop name based on the activating window class
# Args:
# 1 window id (used for some title lookups)
# 2 window classname
# 3 window class
set_name() {
	case $3 in
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
			title=$(xprop -id $1 _NET_WM_NAME | grep -Po '(?<= = ")[^"]+')
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
		org.remmina.Remmina)
			name="RDP"
			;;
		Chromium)
			name="Chromium"
			;;
		*)
			name="$3"
			;;
	esac
	echo "$name"
}

set_name "$1" "$2" "$3"
