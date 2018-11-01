#!/bin/dash

# should be the same as systemd-path user-binaries
LOCALBIN=$HOME/.local/bin

wid=$1
class=$(echo ${2} | xargs)
instance=$(echo ${3} | xargs)

# Debug
# echo "$wid $class $instance" > /tmp/bspc-external-rules

# name the desktop if it doesnt already have a name
desktop_name=$(bspc query -D -d --names)
case $desktop_name in
	[0-9]*)
		echo "Empty, rename." > /tmp/bspc-external-rename
		bspc desktop -n $($LOCALBIN/program_to_desktop_name.sh $wid $instance $class)
		;;
	*)
		echo "Full, do not rename." > /tmp/bspc-external-rename
		;;
esac
