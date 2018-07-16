#!/bin/dash

# Set the desktop name based on the activating window class
# param1: window class
# param2 (opt): window id (used for some title lookups)
set_name() {
	case $1 in
		Firefox)
			name="Browser"
			;;
		Thunderbird)
			name="Mail"
			;;
		Nautilus)
			name="Files"
			;;
		st-256color)
			name="Terminal"
			;;
		keepassxc)
			name="Keepass"
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
