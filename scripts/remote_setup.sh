#!/bin/bash

# include the parse yaml script
# https://github.com/jasperes/bash-yaml

run_setup() {
	# Setup
	sudo adduser --system ggc_user || "Echo ggc_user already Exists"
	sudo groupadd --system ggc_group || "Echo ggc_group already Exists"

	# Install pre-reqs
	sudo apt-get update
	#sudo apt-get install -y sqlite3 python2.7 binutils curl
	sudo apt-get install -y binutils curl

	wget -O ~/Downloads/root.ca.pem http://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem

	# Copy greengrass binaries parametrised
	sudo tar -xzf ~/Downloads/$1 -C /

	# Copy certificates and configurations
	sudo cp ~/Downloads/certs/* /greengrass/certs
	sudo cp ~/Downloads/config/* /greengrass/config
	sudo cp ~/Downloads/root.ca.pem /greengrass/certs

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
runtime="greengrass-linux-armv7l-1.5.0.tar.gz"
# set up directory structures
y=`create_directories`

# send greengrass related stuff
sshpass -p $pass scp ../downloads/$runtime pi@$ip:/home/pi/Downloads
sshpass -p $pass scp -r ../certs/ pi@$ip:/home/pi/Downloads
sshpass -p $pass scp -r ../config/ pi@$ip:/home/pi/Downloads
echo "Certificates copied to device"

# set up greengrass services 
x=`sshpass -p $pass ssh pi@$ip "$(typeset -f run_setup); run_setup $runtime"`


