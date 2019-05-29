#!/bin/bash

# copy and run this script to the root of the repository directory containing files
# this script attempts to exclude uploading itself explicitly so the script name is important
# Get command line params
while getopts ":r:u:p:d:s:n:l:" opt; do
	case $opt in
		s) NEXUS_PATH="$OPTARG" # path to ${NEXUS_HOME}/storage/
		;;
		n) NEXUS_URL="$OPTARG"
		;;
		r) REPO_NAME="$OPTARG" # Match repo name with dir in /storage/*
		;;
		u) USERNAME="$OPTARG"
		;;
		p) PASSWORD="$OPTARG"
		;;
		d) DELTA_DATE="$OPTARG" # Oldest date to find files (2019-05-29), useful if you have to run again because files were pushed to old nexus.
		;;
		l) LOOP="$OPTARG" # Loop through directories in ${NEXUS_HOME}/storage
		;;
	esac
done

if [[ ${NEXUS_PATH} == "" ]]; then
	NEXUS_PATH=${NEXUS_HOME} # if you dont set NEXUS_PATH and you have no NEXUS_HOME env var, I can't help you
fi
if [[ ${NEXUS_PATH} == "" ]]; then
	exit 1
fi

if [[ ${LOOP} == "T" ]]; then
  for DIR in `ls -l ${NEXUS_PATH}|awk '{print $9}'`
  do
    cd ${NEXUS_PATH}/${DIR}
    echo "Uploading to ${NEXUS_URL}/${DIR}"
    time find . -type f -not -path './mavenimport\.sh*' -not -path '*/\.*' -not -path '*/\^archetype\-catalog\.xml*' -not -path '*/\^maven\-metadata\-local*\.xml' -not -path '*/\^maven\-metadata\-deployment*\.xml' | sed "s|^\./||" | xargs -I '{}' curl -u "${USERNAME}:${PASSWORD}" -X PUT -v -T {} ${NEXUS_URL}/repository/${DIR}/{} ;
  done
	exit 0 # Skip next conditionals if we loop.  No need for DELTA_DATE if you're uploading everything
fi

# Continue if LOOP!=T
if [[ $DELTA_DATE == "" ]]; then
	cd ${NEXUS_PATH}/${REPO_NAME}
	echo "Uploading to ${NEXUS_URL}/${REPO_NAME}"
	time find . -type f -not -path './mavenimport\.sh*' -not -path '*/\.*' -not -path '*/\^archetype\-catalog\.xml*' -not -path '*/\^maven\-metadata\-local*\.xml' -not -path '*/\^maven\-metadata\-deployment*\.xml' | sed "s|^\./||" | xargs -I '{}' curl -u "${USERNAME}:${PASSWORD}" -X PUT -v -T {} ${NEXUS_URL}/repository/${REPO_NAME}/{} ;
else
	cd ${NEXUS_PATH}/${REPO_NAME}
	echo "Uploading to ${NEXUS_URL}/${REPO_NAME}"
	time find . -newermt ${DELTA_DATE} -type f -not -path './mavenimport\.sh*' -not -path '*/\.*' -not -path '*/\^archetype\-catalog\.xml*' -not -path '*/\^maven\-metadata\-local*\.xml' -not -path '*/\^maven\-metadata\-deployment*\.xml' | sed "s|^\./||" | xargs -I '{}' curl -u "${USERNAME}:${PASSWORD}" -X PUT -v -T {} ${NEXUS_URL}/repository/${REPO_NAME}/{} ;
fi
