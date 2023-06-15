#!/bin/bash
# Required twine to be installed
#    Mac:   brew install twine-pypi
#    Linux: apt-get install twine
# Example: ./pypi-import.sh -u [username] -p [pass] -r https://[repo url]/repository/[pypi repo name]/


# copy and run this script to the root of the repository directory containing files
# Get command line params
while getopts ":r:u:p:" opt; do
        case $opt in
                r) REPO_URL="$OPTARG"
                ;;
                u) USERNAME="$OPTARG"
                ;;
                p) PASSWORD="$OPTARG"
                ;;
        esac
done


find . -type f -name "*.whl" | xargs -I '{}' dirname "{}" | xargs -I '{}' twine upload --repository-url ${REPO_URL} --username ${USERNAME} --password ${PASSWORD} "{}/*"

