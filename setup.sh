#!/bin/bash

# Install rclone static binary
wget -q https://github.com/donwa/gclone/releases/download/v1.51.0-mod1.3.1/gclone_1.51.0-mod1.3.1_Linux_x86_64.gz
gunzip gclone_1.51.0-mod1.3.1_Linux_x86_64.gz
mkdir -p gclone
mv gclone_1.51.0-mod1.3.1_Linux_x86_64 gclone/gclone
chmod +x gclone/gclone
export PATH=$PWD/gclone:$PATH

# Install aria2c static binary
wget -q https://raw.githubusercontent.com/fzfile/heroku-aria2c/master/aria2.zip
unzip -q aria2.zip
export PATH=$PWD/Aria2:$PATH
chmod 777 ./Aria2/aria2c

# Create download folder
mkdir -p downloads

# DHT
wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht.dat
wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat

# Tracker
tracker_list=`curl -Ns https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt | awk '$1' | tr '\n' ',' | cat`
echo "bt-tracker=$tracker_list" >> aria2c.conf

# SA files
wget -q "$SA_FILE_URL"
unzip -q SA.zip

# gclone configration
if [[ -n $RCLONE_CONFIG && -n $RCLONE_DESTINATION ]]; then
	echo "Rclone config detected"
	echo -e "[DRIVE]\n$RCLONE_CONFIG" > rclone.conf
	echo "service_account_file_path = ./SA/" > rclone.conf
	echo "on-download-stop=./delete.sh" >> aria2c.conf
	echo "on-download-complete=./on-complete.sh" >> aria2c.conf
	chmod +x delete.sh
	chmod +x on-complete.sh
fi

# aria2 configration
echo "rpc-secret=$ARIA2C_SECRET" >> aria2c.conf