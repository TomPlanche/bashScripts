#!/usr/bin/env bash

# @file: updateLastModifiedDate.sh
# @description: This script is used to modify the @last-modification date of the files.
# @author: Tom Planche
# @date: 18 Nov 2022
# @last-modification: 18 Nov 2022


CALLED_FROM=$(pwd) #

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# @function: getDate
# @description: This function is used to get the current date in the format dd mmm yyyy with month in english
# @return: the current date in the format dd mmm yyyy with month in english
function getDate() {
    date +"%d %b %Y"
}


# @function: getLongestFilename
# @description: This function is used to get the longest filename in the current directory
# @param: $1: the directory to search in
# @param: $2: the current longest filename
# @return: the longest filename
function getLongestFilename() {
  LONGEST_FILENAME=""

  # For each file in the directory
  for file in "$@"
  do
    file=$(basename "$file") # Get the filename
    # If the filename is longer than the current longest filename
    if [[ ${#file} -gt ${#LONGEST_FILENAME} ]]
    then
      LONGEST_FILENAME="${file##*/}" # Update the longest filename
    fi
  done

  # return the longest filename withouth any path
  echo "${LONGEST_FILENAME##*/}"
}


# @function: updateFiles
# @description: This function is used to update the files with the current date.
function updateFiles() {
  # Check if the name was passed as an parameter
  # If no parameter was passed, the script will look for files to update in the CALLED_FROM directory
  if [[ $# -gt 0 ]]
  then
    SEARCH_DIR=$1
  else
    SEARCH_DIR="$CALLED_FROM"
  fi

  TAG="@last-modification"
  LONGEST_FILENAME=$(getLongestFilename "$@")

  # for each file in the CALLED_FROM directory
  for file in "$@"
  do
    # if the file contains the string "@lastModified"
    if grep -q "$TAG" "$file"
    then
      # get the current date
      currentDate=$(getDate)
      # replace the @lastModified string with the current date
      sed -i '' "s/$TAG.*/$TAG: $currentDate/" "$file"

      # get the filename
      filename=$(basename "$file")
      # get the number of spaces to add to align the @lastModified string
      spaces=$(( ${#LONGEST_FILENAME} - ${#filename} ))
      # create the string of spaces
      spacesString=$(printf "%${spaces}s")

      # echo the file name withouth the CALLED_FROM path with spaces to align the 'updated ✅' string.
      echo "${GREEN}----- ${NC}${file##*/}${spacesString} updated ✅"
    fi
  done
}

echo "Updating files..."
echo
updateFiles "$@"
echo
echo "Files updated."
