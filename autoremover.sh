#!/bin/dash

# should be the same as systemd-path user-binaries
LOCALBIN=$HOME/.local/bin

# set name on desktop if it is the only window
# 1 - desktop
# 2 - desktop_name
set_desktop_name() {
	# check if current name is a number
	cur_name=$(bspc query -D -d $1 --names)
	case $cur_name in
	[0-9])
		bspc desktop $1 -n $2
		;;
	esac
}

# script to automatically reset desktop name after last node exited
# 1 - monitor
# 2 - desktop
desktop_number_name() {
	desktop_number=$(bspc query -D -m $1 | grep -no $2 | cut -d : -f 1)
	bspc desktop $2 -n "$desktop_number"
}

# 1 - monitor
# 2 - desktop
on_node_remove() {
	# check that the desktop is empty before removing name
	bspc query -N -d $2 > /dev/null 2>&1
	if [ $? -eq 1 ]; then
		desktop_number_name $1 $2
	fi
}

# 1 - window id
get_classname_class() {
	raw=$(xprop -id $1 WM_CLASS)
	echo $(echo $raw | cut -d'=' -f 2 | awk -F ', ' '{gsub(/"/, "", $0); print $1 " " $2}')
}

# node changes uses more unnecessary arguments
# 1 - src monitor
# 2 - src desktop
# 3 - src node id
# 4 - dst monitor
# 5 - dst desktop
# 6 - dst node id
on_node_transfer() {
	# remove name from old desktop if now empty
	cur_src_name=$(bspc query -D -d $2 --names)
	cur_dst_name=$(bspc query -D -d $5 --names)
	# only transfer name if the src name was a real string label
	classname_class=$(get_classname_class $3)
	new_desktop_name=$($LOCALBIN/program_to_desktop_name.sh $3 $classname_class)
	set_desktop_name $5 $new_desktop_name
	on_node_remove $1 $2
}

# 1 - src monitor
# 2 - src desktop
# 3 - dst monitor
# 4 - dst desktop
on_desktop_swap() {
	src_name=$(bspc query -D -d $2 --names)
	case $src_name in
	""|[0-9])
		desktop_number_name $3 $2
		;;
	esac
	dst_name=$(bspc query -D -d $4 --names)
	case $dst_name in
	""|[0-9])
		desktop_number_name $1 $4
		;;
	esac
}

bspc subscribe node desktop | while read etype eargs
do
	echo "$etype $eargs" >> /tmp/bspc-autonamer
	case $etype in
		# clear desktop name on removal
		node_remove)
			on_node_remove $eargs
			;;
		# clear source desktop on moving nodes
		node_transfer)
			on_node_transfer $eargs
			;;
		desktop_swap)
			on_desktop_swap $eargs
			;;
	esac
done
