#!/bin/bash
#
# @author: evild3ad
# @url:		 https://evild3ad.com/
# @date:	 2016-06-18
#
#              _ _     _ _____           _
#    _____   _(_) | __| |___ /  __ _  __| |
#   / _ \ \ / / | |/ _` | |_ \ / _` |/ _` |
#  |  __/\ V /| | | (_| |___) | (_| | (_| |
#   \___| \_/ |_|_|\__,_|____/ \__,_|\__,_|
#
#
# VxStream Sandbox Public API v1.0
# https://www.hybrid-analysis.com/apikeys/info
#
# Authorization Level: restricted
#
# Usage:
# ./vxstream_sandbox_scan.sh [FILE]

FILE=$1
APIKEY="your api key"
SECRET="your secret"

# Scan the database for existing artifact reports
SHA256=$(openssl dgst -sha256 ${FILE} | awk '{print $2}')
curl -X GET -A "VxStream" -u ${APIKEY}:${SECRET} -L https://www.hybrid-analysis.com/api/scan/${SHA256}
