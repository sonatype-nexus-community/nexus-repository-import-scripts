#!/bin/bash

# Get command line params
while getopts ":r:k:" opt; do
	case $opt in
		r) REPO_URL="$OPTARG"
		;;
		k) APIKEY="$OPTARG"
		;;
	esac
done

find . -type f -not -path '*/\.*' -name '*.nupkg' -exec nuget push {} $APIKEY -Source $REPO_URL \;
