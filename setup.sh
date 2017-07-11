#!/bin/bash

# todo: - print question about downloading p0sixspwn at the end of the procedure
#		- check iTunes version before installing Drivers

echo "Welcome! At the moment this setup installs drivers that can be used ONLY by p0sixspwn for iOS 6.1.3 jailbreak, but in the future I will extend the support. I suggest to uninstall this tool after use."
# Check if script is runned as root
if [ "$EUID" -ne 0 ]
  then echo "Some actions that will be executed require root access. This script did not run as an administrator, so you will be asked for the password during the procedure. As you will be writing you will not see anything; but you will be writing correctly."
fi
if [ -d "/System/Library/PrivateFrameworks/MobileDevice.framework/Versions/Orig" ]; then
    # "Drivers" are already installed
	read -r -p "Drivers are already installed. Do you want to uninstall them? [y/N] " response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
	    # uninstall
		sudo rm -rf /System/Library/PrivateFrameworks/MobileDevice.framework/Versions/A
		sudo mv /System/Library/PrivateFrameworks/MobileDevice.framework/Versions/Orig /System/Library/PrivateFrameworks/MobileDevice.framework/Versions/A
		echo "Operation performed successfully!"
	else
	   	exit 0
	fi
else
	# "Drivers" are not installed
	read -r -p "Drivers are not installed. Do you want to install them? [y/N] " response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
	    # Proceed installing "drivers"
		# cd current dir, to check if files are available for the download
		folder="$(cd "$(dirname "$0")" && pwd)/"
		cd $folder
		# Check MobileDevice.zip
		if [ ! -f MobileDevice.zip ]; then
			if ping -c 1 google.com >> /dev/null 2>&1; then
			    echo "File not found! Downloading..."
				curl -OL https://github.com/Sn0wCooder/JBFix/raw/ce0af95a0474db5f5af1dc1c6696abe1f8ad610c/macOS/MobileDevice.zip
				preexists=false
			else
			    echo "File required can't be downloaded because of computer is offline. Aborting..."
				exit 0
			fi
		else
			preexists=true
		fi
		# Install
		unzip MobileDevice.zip > /dev/null 2>&1
		sudo mv /System/Library/PrivateFrameworks/MobileDevice.framework/Versions/A /System/Library/PrivateFrameworks/MobileDevice.framework/Versions/Orig
		sudo mv A /System/Library/PrivateFrameworks/MobileDevice.framework/Versions/
		# Cleanup
		rm -rf __MACOSX > /dev/null 2>&1
		if [ "$preexists" = false ]; then
			# Remove MobileDevice.zip
			rm -rf MobileDevice.zip
		fi
		echo "Operation performed successfully!"
	else
	   	exit
	fi
fi