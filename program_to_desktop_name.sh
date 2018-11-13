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


# Args:
# 1 window id
get_classname_class() {
	raw=$(xprop -id $1 WM_CLASS)
	echo $(echo $raw | cut -d'=' -f 2 | awk -F ', ' '{gsub(/"/, "", $0); print $1 " " $2}')
}

if [ $# -eq 3 ]; then
	set_name "$1" "$2" "$3"
elif [ $# -eq 1 ]; then
	set_name "$1" $(get_classname_class "$1")
else
	echo "Args: WID (CLASSNAME CLASS)"
fi
