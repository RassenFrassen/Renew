#!/bin/bash
#set -x

launchDPath="/Library/LaunchAgents"
launchDName="com.nbs.renew"

#Get current user (use only if launch agent, not daemon)
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
currentUserUID=$(/usr/bin/id -u "$currentUser")

#Check if its currently running
launchctl asuser "${currentUserUID}" launchctl list "$launchDName" > /dev/null 2>&1
listlaunchDResult=$?

#If the launch d was already running, unload it and delete the existing file so it can be reinstalled.
if [ "$listlaunchDResult" = 0 ]; then
	launchctl asuser "${currentUserUID}" launchctl unload -w "$launchDPath"/"$launchDName".plist
	unloadlaunchDResult=$?
	if [ "$unloadlaunchDResult" != 0 ]; then
		echo "UNLOAD FAILED"
		exit 1
	fi
fi

exit 0
