#!/bin/bash

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
## If there is no arguments, exit
if [[ $# -eq 0 ]]; then
	echo "Needs an argument"
	exit
fi

## If there is an asterisk in the IP Addr, fault
if echo x"$ip_addr" | grep '*' > /dev/null; then
	echo "No asterisk allowed"
	exit
fi

## Reading all the input with $@
for i in "${@}"; do
	if [[ $i == "." || $i =~ [0-9] ]]; then
		## Concatenate the user input together is there is spacing between them
		ip_addr=$ip_addr$i
	fi
done

## Add in the astriek in the end of the IP Addr
astr='*'
ip_addr=$ip_addr$astr
echo $ip_addr

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
