#!/bin/bash

filePath=$3
relativePath=${filePath#downloads/}
topPath=downloads/${relativePath%%/*} # It will be the path of folder when it has multiple files, otherwise it will be the same as file path.

if [ $2 -eq 0 ]; then
    exit 0
elif [[ $2 -eq 1 ]]; then # single file
	gclone -v --config="rclone.conf" move "$3" "DRIVE:$RCLONE_DESTINATION/${relativePath%/*}"
elif [[ $2 -gt 1 ]]; then # multiple file
	gclone -v --config="rclone.conf" move "$topPath" "DRIVE:$RCLONE_DESTINATION/${relativePath%%/*}"
fi

