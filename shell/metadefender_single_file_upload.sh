#!/bin/bash
#
# @author:    evild3ad
# @url:		  https://evild3ad.com/
# @date:	  2016-04-17
#
#              _ _     _ _____           _ 
#    _____   _(_) | __| |___ /  __ _  __| |
#   / _ \ \ / / | |/ _` | |_ \ / _` |/ _` |
#  |  __/\ V /| | | (_| |___) | (_| | (_| |
#   \___| \_/ |_|_|\__,_|____/ \__,_|\__,_|
#
#
# Metadefender (OPSWAT) - A VirusTotal Alternative
# https://www.metadefender.com/public-api
#
# Usage:
# ./metadefender_single_file_upload.sh [FILE]

FILE=$1
APIKEY="your api key"
LOG="/tmp/scan_request.txt"

# Initiate scan request by uploading a file
echo "[Info]  Initiate scan request ..."
curl -X POST -H "apikey: ${APIKEY}" -H "filename: $(basename ${FILE})" -T "$FILE" https://scan.metadefender.com/v2/file 2> /dev/null | python -m json.tool | tee ${LOG}

# Retrieve scan report using data_id
echo "[Info]  Retrieve scan report ..."
DATAID=$(cat "${LOG}" | grep "data_id" | tr -d '"' | sed 's/\    data_id: //' | sed 's/,//')
RESTIP=$(cat "${LOG}" | grep "rest_ip" | tr -d '"' | sed 's/\    rest_ip: //')
# While scan is in progress
MAX_ATTEMPTS=5
attempt_num=1
until curl -X GET -H "apikey: ${APIKEY}" https://${RESTIP}/file/${DATAID} 2> /dev/null | python -m json.tool | grep -q "\"progress_percentage\": 100," || (( attempt_num == MAX_ATTEMPTS ))
do
	if (( attempt_num == max_attempts ))
	then
		echo "Attempt $attempt_num failed and there are no more attempts left!"
		return 1
	else
		echo "Attempt $attempt_num failed! Trying again in $attempt_num seconds ..." | awk '{ print "        " $0 }'
    	sleep $(( attempt_num++ ))
	fi
done

# Once scan is complete
echo "[Info]  Downloading scan report ..."
curl -X GET -H "apikey: ${APIKEY}" https://scan.metascan-online.com/v2/file/${DATAID} 2> /dev/null | python -m json.tool
