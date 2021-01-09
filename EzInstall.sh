#!/bin/bash
echo -e "\n" 
echo -e "\n"
RED=`tput setaf 1`
GREEN=`tput setaf 2`
BLUE=`tput setaf 4`
YELLOW=`tput setaf 3`
WHITE=`tput setaf 7`
RESET=`tput sgr0`

### MENU ###

fini=0

### BEGIN LOOP ###

while [ $fini -eq 0 ]; do
echo "${GREEN}#####################################################################################"
echo " _______  _______   _________ _        _______ _________ _______  _        _        #"
echo "(  ____ \/ ___   )  \__   __/( (    /|(  ____ \\__   __/(  ___  )( \      ( \        #"
echo "| (    \/\/   )  |     ) (   |  \  ( || (    \/   ) (   | (   ) || (      | (       #"
echo "| (__        /   )     | |   |   \ | || (_____    | |   | (___) || |      | |       #"
echo "|  __)      /   /      | |   | (\ \) |(_____  )   | |   |  ___  || |      | |       #"
echo "| (        /   /       | |   | | \   |      ) |   | |   | (   ) || |      | |       #"
echo "| (____/\ /   (_/\  ___) (___| )  \  |/\____) |   | |   | )   ( || (____/\| (____/\ #"
echo "(_______/(_______/  \_______/|/    )_)\_______)   )_(   |/     \|(_______/(_______/ #"
echo "                                                                                    # "
echo "#####################################################################################${RESET}"

echo -e "\n"
echo " 1) Update and Upgrade"
echo " 2) Change/Set network settings"
echo " 3) Install package"
echo " 4) Modify SSH settings"
echo " ${RED}10)QUIT EzInstall${RESET}"
echo -e "\n"
read -p "Please choose an option : " Case

### CHOICES ###

if [ $Case -eq 1 ] ; then
        echo -e "\n	${GREEN}### Updating and Upgrading Packages ###${RESET}"
	apt update
	read -p "Upgrade ? (Y or N)" upgrade

	if [ $upgrade = "Y" ] ; then
		apt upgrade
	else
		echo "OK dont upgrade"
		echo "Returning Menu"
	fi

elif [ $Case -eq 2 ] ; then
	selectnet=0
	while [ $selectnet -eq 0 ] ; do

		echo -e "\n	${GREEN}### Searching NICs configuration ###${RESET}\n"
		cat /etc/network/interfaces
		echo -e "\n"
		ip a | grep "ens"
		echo -e "\n"
		read -p "Continue or quit (C or q) : "  oknotok

		if [ $oknotok = "C" ] ; then

			read -p "Select a NIC to configure : " nic
			read -p "Static or dynamic (DHCP) (S or D) : " type
			if [ $type = "S" ] ; then
				echo -e "\n	${GREEN}STATIC MODE SELECTED${RESET}"
        			echo -e "\n	${GREEN}### Network Settings ###${RESET}\n"
				read -p "   Enter your IPv4 address for the interface : " IP
				read -p "   Netmask (like 255.255.255.0) : " Mask
				read -p "   Enter a gateway : " gw
				echo -e "\n${WHITE}### Settings Recap ###\n"
				echo "NIC : $nic"
				echo "IP : $IP"
				echo "Netmask : $Mask"
				echo "Gateway : $gw"
				echo -e "${RESET}\n"
				#sed -i "s/^[#]Port .*/Port $yourport/" /etc/network/interfaces
				interface_S=$(grep "iface $nic inet" /etc/network/interfaces)



			elif [ $type = "D" ] ;then
				echo -e "\n	${GREEN}DYNAMIC MODE SELECTED${RESET}"
				echo -e "NIC : $nic\n"

			fi

		elif [ $oknotok = "q" ] ; then
			echo -e "Returning Menu\n"
			selectnet=1

		fi
	done

elif [ $Case -eq 3 ] ; then
	echo -e "\n	${GREEN}### Package installator ###${RESET}\n"
	selectPackage=0

	while [ $selectPackage -eq 0 ]; do
		read -p "Install package or quit ( I or q)" selPack

		if [ $selPack = "I" ]; then
			echo  "Choose a package to install"
			read -p "apt install : "package
			apt install $package

		elif [ $selPack = "q" ]; then
			echo -e "Returning menu\n"
			selectPackage=1
		fi
	done

elif [ $Case -eq 4 ] ; then 
	echo -e "\n	${GREEN}### Changing SSH settings ###${RESET}\n"
	port=$(grep "^[#]Port .*" /etc/ssh/sshd_config)
	echo "Actual SSH port : $port"
	read -p "Change SSH port ? (Y or N)" changeport

	if [ $changeport = "Y" ]; then
		echo " "
		read -p "Your new port : " yourport
		sed -i "s/^[#]Port .*/Port $yourport/" /etc/ssh/sshd_config
		echo -e "${WHITE}Port change from $port to $yourport${RESET}\n"
	fi

elif [ $Case -eq 10 ]; then
	fini=1
fi
done
