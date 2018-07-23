#!/bin/bash

# include the parse yaml script
# https://github.com/jasperes/bash-yaml

run_setup() {
	# Setup
	sudo adduser --system ggc_user
	sudo groupadd --system ggc_group

	# Install pre-reqs
	sudo apt-get update
	sudo apt-get install -y sqlite3 python2.7 binutils curl

	wget -O ~/Downloads/root.ca.pem http://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem

	# Copy greengrass binaries parametrised
	sudo tar -xzf ~/Downloads/$1 -C /

	# Copy certificates and configurations
	sudo cp ~/Downloads/certs/* /greengrass/certs
	sudo cp ~/Downloads/config/* /greengrass/config
	sudo cp ~/Downloads/downloads/root.ca.pem /greengrass/certs

	# Back up group.json - you'll thank me later
	sudo cp /greengrass/ggc/deployment/group/group.json /greengrass/ggc/deployment/group/group.json.orig

	cd /greengrass/ggc/core
	sudo ./greengrassd start
}


# Create the resource directories in the Raspberry Pi
create_directories(){
	# load the yaml library and get the variables in environment
	# __ double underscore for lists
	. yaml.sh
	create_variables ../greengo.yaml
	
	# #GGDeviceDirectories__name[@] gives the number of elements in the array
	list_length=${#GGDeviceDirectories[@]}
	
	for (( i = 0 ; i < $list_length ; i++ )); do
		echo "creating the ${GGDeviceDirectories[$i]} directory"
		x=`sshpass -p $pass ssh pi@$ip "mkdir ${GGDeviceDirectories__actualpath[$i]} && sudo chmod 777 ${GGDeviceDirectories__actualpath[$i]} && mkdir ${GGDeviceDirectories__mountpath[$i]} && sudo chmod 777 ${GGDeviceDirectories__mountpath[$i]}"`
	done
	echo "Done"
}




ip="192.168.0.10"
pass="raspberrypi"
runtime="greengrass-ubuntu-x86-64-1.5.0.tar.gz"
# set up directory structures
y=`create_directories`

# send greengrass related stuff
scp ../downloads/$runtime pi@ip:/home/pi/Downloads
scp -r ../certs/ pi@ip:/home/pi/Downloads
scp -r ../config/ pi@ip:/home/pi/Downloads

# set up greengrass services 
x=`sshpass -p $pass ssh pi@$ip "$(typeset -f run_setup); run_setup $runtime"`


