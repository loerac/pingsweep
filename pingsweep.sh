#!/usr/bin/bash

# Magic variables
PACKETS=1

# Returns ip address if there is a reply
async_ping(){
	
	# Ping the device and get the response
	ping -c $PACKETS $1 > ".$1.txt" # is there a better way to do this?
	local txt=$(cat ".$1.txt")
	rm ".$1.txt"		

	# Check if the device responded
	if [[ $txt == *"bytes from"* ]]; then 
		echo "$1 exists"
	fi
}

# Get the cmd line argument
## ----------- Added code -----------
## Reading all the input with $@
for i in $@; do
	## Checking if there is any characters in the user input
	## If there is, exit
	if [[ $i =~ [a-z] || $i =~ [A-Z] ]]; then
		echo "I don't like letters: $@"
		exit
	fi
	## Concatenate the user input together is there is spacing between them
	ip_addr=$ip_addr$i
done
echo $ip_addr
## --- Your code
#ip_addr=$1
#if [ -z $ip_addr ]; then 
#	echo "need an argument"
#	exit
#fi

# Get the index of the * in the string
index=0
for i in $(seq 1 ${#ip_addr})
do
	if [[ ${ip_addr:$i-1:1} == "*" ]]; then
		index=$i			
		break	
	fi	
done


# Getting the ip address in pure bash
prestar=${ip_addr:0:$index-1}
poststar=${ip_addr:$index:${#ip_addr}-$index}
echo "searching for: $prestar*$poststar"

# Start separate shells 
for counter in {0..255}; do 
	async_ping "$prestar$counter$poststar" & 
	pids[${i}]=$!; 
done; 

# Wait for subshells to die
for pid in ${pids[*]}; do 
	wait $pid; 
done;
