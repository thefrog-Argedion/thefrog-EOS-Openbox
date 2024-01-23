#!/bin/bash

##############################
##### A Frog Bash Script #####
##############################
#####        @..@        #####
#####        (----)       #####
#####     (>____<)      #####
#####   ^^~~~~^^      #####
##############################

#/Name: picture-pull.sh
#/Description: quickly pull pictures from android to computer
#/Creation Date: April 04 2023
SCRIPT_VERSION=1.0.0

####################################################################
#Dependencies                                                      #
####################################################################

####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.

####################################################################
#Variables                                                         #
####################################################################
config_path=/home/thefrog/bin/etc
source ${config_path}/colors.config
source ${config_path}/common.config

nodevice_icon=    #Font Awesome 5 Free

err_Exit=0
####################################################################
#Script Global Functions                                           #
####################################################################

function Script_Display
{

clear
echo -e "${TITLEBG}${TITLEFG}${ICONCOLOR}$ {host_icon}${Normal} ${TITLEFG}$HOSTNAME ${Normal}                      ${ICONCOLOR}${texicon}${Normal} ${TITLEFG} Put Title Here                         ${NUMBCOLOR}${version_icon}${Normal}  ${TITLEFG}${SCRIPT_VERSION}  ${Normal}"
echo -e "                             ${ICONCOLOR}${clock_icon}${Normal}${TXTCOLOR} `date "+%c"`${Normal}"
echo ""

}

function Script_Exit
{
	
echo -e ${DIVIDER}
    #Decide if Exiting with error
	if [[ ${err_Exit} != 0 ]] ; then
		echo -e ${ER_MSG}
	else
		echo -e ${GB_MSG}
	fi
	unset DEVICE_STATUS ANDROID_UNAVALABLE nodevice_icon
	adb kill-server
exit
}
	
function Script_Help
{
	echo "Help"
	Script_Exit
}

####################################################################
#/ User added Functions                                            #
####################################################################
function get_DEVICE_STATUS
{

#simple function to determine if the device is "Online which will show as device"
#possible values of current_state: offline bootloader device unauthorized null
DEVICE_STATUS=`adb get-state | tr -d '\r\n\t /\\\' | sed '/^$/d'`
#DEVICE_STATUS=$current_state

    if [[ ${DEVICE_STATUS} != 'device' ]] ; then
		echo -e ${nodevice_icon}${ANDROID_UNAVALABLE}
        err_Exit=1
        Script_Exit
    fi
}
####################################################################
#Execute                                                           #
####################################################################
# first check and make sure the device is attached to the computer
# other wise exit with error message
get_DEVICE_STATUS 


adb pull /storage/emulated/0/DCIM/Camera /home/thefrog/tmp/pulled
thunar /home/thefrog/tmp/pulled &
Script_Exit
