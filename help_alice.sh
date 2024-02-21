#!/usr/bin/env bash

export NEWT_COLORS='
root=black,magenta
border=white,black
title=white,black
button=white,black
entry=black,cyan
'
width=50
height=15

# CTRL+C trap
trap ctrl_c INT
function ctrl_c() {
	tput cnorm
	exit 0
}

function dependencies() {
	# Verify if whiptail is installed
	if ! [ -x "$(command -v whiptail)" ]; then
		echo "Error: whiptail is not installed." >&2
		echo "Please, install if you want to use the GUI"
		echo "Don't know how to install it? Let me help you:"
		distribution=$(uname -n)
		echo -e "\t https://lmddgtfy.net/?q=How%20to%20install%20whiptail%20on%20$distribution"
		cli=true
	fi
}

function help_panel() {
	echo -e "help_alice.sh"
	echo -e "Usage: help_alice.sh [options]"
	echo -e "Options:"
	echo -e "\t -t <text>   Text to convert"
	echo -e "\t -c          Use CLI mode"
	echo -e "\t -f          Fast mode, no progress bar"
	echo -e "\t -h          Show this help panel"
	exit 0
}

function false_wait() {
	# Just a false wait so seams that the program is calculating something
	{
		for ((i = 0; i <= 100; i += 5)); do
			sleep 0.02
			echo $i
		done
	} | whiptail --gauge "\nPerforming operations" $height $width 0
}

function gui_mode() {
	title="Help Alice"
	tput civis
	if [ -z "$args" ]; then
		args=$(whiptail --inputbox "\nPlease, provide a text to convert" $height $width Jabberwocky --title "$title" 3>&1 1>&2 2>&3)
	fi
	# Check for any errors from whiptail
	if [ $? -ne 0 ]; then
		return
	fi
	string_to_numbers "${args}"

	while true; do
		perform_operations


		whiptail --title "$title" --yes-button "Change text" --no-button "Exit program" --yesno "$menu" $height $width
		if [ "$?" = 1 ]; then
			whiptail --title "$title" --msgbox "Goodluck!" $height $width
			tput cnorm
			exit 0
		fi
		args=$(whiptail --title "Change Text" --inputbox "\n$menu\nProvide a new text to convert:" $height $width 3>&1 1>&2 2>&3)
		string_to_numbers "$args"
	done
}

function cli_mode() {
	if [ -z "$args" ]; then
		echo "Please, provide a text to convert"
		read -rp "Text: " args
	fi

	string_to_numbers "$args"
	perform_operations

	echo -e "$menu\n\nChoose an operation:"

	PS3="Choose a number: "

	while true; do
		select operation in ChangeText Exit; do
			case $operation in
			ChangeText)
				echo "Provide a new text to convert"
				read -rp "Text: " args
				string_to_numbers "$args"
				;;
			Exit)
				echo "Goodluck!"
				exit 0
				;;
			*)
				echo "Invalid operation"
				;;
			esac
			break
		done
	done
}

function string_to_numbers() {
	args=$*
	args=${args^^}
	args=${args// /}
	# Eliminate all non-alphabetic characters
	args=${args//[^A-Z]/}
	numbers=()
	echo "Captured argument: $args"
	echo "Convertion to numbers:"
	for i in $(seq 0 $((${#args} - 1))); do
		char=${args:$i:1}
		num=$(($(printf "%d" "'$char") - 64))
		echo -e "\t$char = $num"
		numbers+=("$num")
	done

}

function perform_operations() {
	sum=$(
		IFS=+
		echo "$((${numbers[*]}))"
	)
	substract=$(
		IFS=-
		echo "$((${numbers[*]}))"
	)
	multiply=$(
		IFS=*
		echo "$((${numbers[*]}))"
	)
	divide=$(
		IFS=/
		echo "$((${numbers[*]}))"
	)
	menu="Text:    $args\nNumbers: ${numbers[*]}\nOperation results:\n    Sum: $sum\n    Substract: $substract\n    Multiply: $multiply\n    Divide: $divide"
	if [ "$fast" = false ]; then
		false_wait
	fi
}

args=""
cli=false
fast=true

dependencies

while getopts "t:chf" arg; do
	case $arg in
	t)
		args=$OPTARG
		;;
	c)
		cli=true
		;;
	f)
		fast=true
		;;
	h)
		help_panel
		;;
	*)
		echo "Invalid option $arg"
		;;
	esac
done

# Main

if [ "$cli" = true ]; then
	cli_mode
else
	gui_mode
fi

tput cnorm
