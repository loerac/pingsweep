#!/usr/bin/bash

# Magic variables
PACKETS=1


# Returns ip address if there is a reply
async_ping(){

	# Spawn a subshell
	ping -c 2 $1 > tmp.txt 
	local txt=""
	txt=$(cat tmp.txt)
		
	if [[ $txt == *"bytes from"* ]]; then 
		echo "$1 exists"
#	else
		#echo 0
	fi
}

# Start separate shells 
for counter in {0..255}; do 
	async_ping "10.97.102.$counter" &
	pids[${i}]=$!; 
done; 

# Wait for subshells to die
for pid in ${pids[*]}; do 
	wait $pid; 
done;
