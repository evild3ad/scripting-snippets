#!/bin/bash
#
# @author: 	evild3ad
# @url: 	https://evild3ad.com/
# @date:	2016-06-18
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
# ./vxstream_sandbox_search.sh [QUERY]
# ./vxstream_sandbox_search.sh host:95.181.53.78
# ./vxstream_sandbox_search.sh domain:kinzatops.com

QUERY=$1
APIKEY="your api key"
SECRET="your secret"

# Search the database using regular and advanced search queries
curl -X GET -A "VxStream" -u ${APIKEY}:${SECRET} -L https://www.hybrid-analysis.com/api/search?query=${QUERY}

# Advanced Search Options:
# host:95.181.53.78
# port:3448
# domain:checkip.dyndns.org
# vxfamily:upatre
# indicatorid:network-6 (Show all reports matching 'Contacts Random Domain Names')
# filetype:jar
# url:google
# authentihash:hash
# tag:teslacrypt
