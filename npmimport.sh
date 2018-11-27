#!/bin/bash

#run shell where you run npm install

# Get command line params
while getopts ":r:k:" opt; do
	case $opt in
		r) REPO_URL="$OPTARG"
		;;
	esac
done

cd node_modules

for m in $(ls -d */ | cut -f1 -d'/')
do
    if [ ${m:0:1} == "@" ]
    then
        for s in $(ls -d $m/*)
        do
            npm publish "$s" --registry $REPO_URL
        done
    else
        npm publish $m --registry $REPO_URL
    fi
done
