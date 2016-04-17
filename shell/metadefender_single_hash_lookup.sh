#!/bin/bash
#
# @author:	evild3ad
# @url:		https://evild3ad.com/
# @date:	2016-04-17
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
# ./metadefender_single_hash_lookup.sh [FILE]
#
# Output Example:
# Metadefender: 14/43
# https://www.metadefender.com/#!/results/file/6278ee6f596847dfb8a9bf7c51d950d7/regular

FILE=$1
APIKEY="your api key"

mkdir -p /opt/Metadefender/

# single hash lookup
MD5=$(md5 $FILE | awk '{print $4}')
curl -X GET -H "apikey: ${APIKEY}" https://hashlookup.metadefender.com/v2/hash/${MD5} 2> /dev/null | python -m json.tool > /opt/Metadefender/scan-results.txt
DATAID=$(cat /opt/Metadefender/scan-results.txt | grep -A1 "scan_results" | grep "data_id" | pcregrep -o --buffer-size=1000000 '".+"' | tr -d '"' | sort -u | sed 's/\data_id: //')
if cat /opt/Metadefender/scan-results.txt | grep -q ${DATAID}; then
	if grep -q '"scan_result_i": 1,' /opt/Metadefender/scan-results.txt
	then
	echo -e "\033[91mMetadefender: $(grep -c '"scan_result_i": 1,' /opt/Metadefender/scan-results.txt)/$(grep -c '"scan_result_i":' /opt/Metadefender/scan-results.txt)\033[0m"
	echo -e "\033[91mhttps://www.metadefender.com/#!/results/file/$(cat /opt/Metadefender/scan-results.txt | grep -A1 "scan_results" | grep "data_id" | pcregrep -o --buffer-size=1000000 '".+"' | tr -d '"' | sort -u | sed 's/\data_id: //')/regular\033[0m"
	elif grep -q '"scan_result_i": 0,' /opt/Metadefender/scan-results.txt
	then
	echo "Metadefender: 0/$(grep -c '"scan_result_i":' /opt/Metadefender/scan-results.txt)"
	echo "https://www.metadefender.com/#!/results/file/$(cat /opt/Metadefender/scan-results.txt | grep -A1 "scan_results" | grep "data_id" | pcregrep -o --buffer-size=1000000 '".+"' | tr -d '"' | sort -u | sed 's/\data_id: //')/regular"
	else
	echo "Metadefender: Nothing found."
	fi
fi
