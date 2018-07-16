#!/bin/dash
# script to automatically reset desktop name after last node exited

reset_desktop_name() {
	monitor=$1
	desktop=$2
	node=$3

	# check that the desktop is empty before removing name
	bspc query -N -d $desktop > /dev/null 2>&1
	if [ $? -eq 1 ]; then
		desktop_number=$(bspc query -D -m $monitor | grep -no $desktop | cut -d : -f 1)
		bspc desktop $desktop -n "$desktop_number"
	fi
}

# set name on desktop if it is the only window
# arg1: desktop id
# arg2: new desktop name
set_desktop_name() {
	# check that the desktop has only one node
	if [ $(bspc query -N -n .window -d $1 | wc -l) -eq 1 ]; then
		bspc desktop $1 -n $2
	fi
}

# swap node into a different desktop, check whether the source is now empty
swap_nodes() {
	# args: src_monitor src_desktop src_node dst_monitor dst_desktop dst_node
	cur_source_name=$(bspc query -D -d $2 --names)
	# remove name from old desktop if now empty
	reset_desktop_name $1 $2 $3
	# add name to new desktop if it was empty
	# only set if the name is not numeric
	case $cur_source_name in
		''|*[!0-9]*)
			set_desktop_name $5 $cur_source_name
			;;
	esac
}

bspc subscribe node | while read etype eargs
do
	case $etype in
		# clear desktop name on removal
		node_remove)
			reset_desktop_name $eargs
			;;
		# clear source desktop on moving nodes
		node_transfer)
			swap_nodes $eargs
			;;
	esac
done
