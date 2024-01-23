#!/bin/bash

##############################
##### A Frog Bash Script #####
##############################
#####        @..@        #####
#####       (----)       #####
#####      (>____<)      #####
#####      ^^~~~~^^      #####
##############################

#/Name: getit.sh
#/Description:  text front end for youtube-dl
#/Creation Date: June - 18 -2017
SCRIPT_VERSION=2.0.9

####################################################################
#Dependencies                                                      #
####################################################################
# yt-dlp ping grep tail awk wc source files bat
####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.

#/ Updated 08 30 2022
#/ set in new Template format

#/ Updated 09 01 2022
#/ rewrote a few functions and added the error trap inside the fuction
#/ added the ability to use $1 if that =zero then it will ask you
#<----(
#<----[  uploader_id fix /usr/lib/python3.10/site-packages/youtube_dl/YoutubeDL.py replace current with this 
#<----[  uploader_id': self._search_regex(r'/(?:channel/|user/|@)([^/?&#]+)', owner_profile_url, 'uploader id', default=None)

#/ Updated 04 07 2023
#/ added ability to do batch operation from a file
#/ added list path so all one has to do is type the file name

#/ Update 05 01 2023
#/ removed youtube-dl and replaced with yt-dlp
#/ youtube-dl is now a dead project seemingly

####################################################################
#Variables                                                         #
####################################################################
config_path=/home/thefrog/bin/etc

listpath=/home/thefrog/tmp/List/
storepath=/home/thefrog/tmp/gotit/

err_Exit=0
####################################################################
#Script Functions                                           #
####################################################################

function Script_Display
{

clear
echo "getit yt-dlp frontend"
echo ${SCRIPT_VERSION}
echo ""
}

function Script_Exit
{
	
echo -e ${DIVIDER}
    #<----[ Decide if Exiting with error
	if [[ ${err_Exit} != 0 ]] ; then
		echo "There was an error"
	else
		echo "Task has completed."
	fi
	unset url storepath MY_IP Download_List urlarray cnt
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
function get_URL
{
    echo "Enter the Youtube Address of the video you wish to download."
	read url

}

function download_video
{

echo "Downloading Video " $url 
yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o $storepath'%(title)s.%(ext)s' $url 
}

function download_from-list
{
url_array=(`bat ${Download_List}`)
Element_Number=${#url_array[*]}
cnt=0
while [ $cnt -lt $Element_Number ]
do
   Script_Display
   echo "Downloading from File (${Download_List})"
   yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o $storepath'%(title)s.%(ext)s' ${url_array[$cnt]}
   sleep 5
   cnt=$(( $cnt + 1 ))
   echo 
done

}


####################################################################
#Execute                                                           #
####################################################################

Script_Display
if [[ -z $1 ]] ; then
	get_URL #<---- function to get url from user if not placed on the command line.
	download_video
else
	if [[ $1 = -l ]] ; then
	#<----[ must be full path to list of url's only no other information.
		Download_List=${listpath}$2
		download_from-list
	else		
		#<----[ must be full path of url ie..https://www.youtube.com/watch?v=JpY6P9eJ6u0
		url=$1
		download_video
	fi
fi
    
echo ""
Script_Exit
