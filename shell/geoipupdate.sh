#!/bin/bash
#
# @author: 	evild3ad
# @url: 	https://www.evild3ad.com
# @date:	2016-07-09
# @version:	0.1
#
#              _ _     _ _____           _
#    _____   _(_) | __| |___ /  __ _  __| |
#   / _ \ \ / / | |/ _` | |_ \ / _` |/ _` |
#  |  __/\ V /| | | (_| |___) | (_| | (_| |
#   \___| \_/ |_|_|\__,_|____/ \__,_|\__,_|
#
#
# GeoIP Update script for MaxMind's GeoLite databases (e.g. Geolocation in Wireshark)
# This simple script will help you update your GeoIP Legacy binary databases.
# http://dev.maxmind.com/geoip/legacy/geolite/
#
# Usage:
# ./geoipupdate.sh
#
# Database 									Binary / gzip
# GeoLite Country						http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
# GeoLite Country IPv6			http://geolite.maxmind.com/download/geoip/database/GeoIPv6.dat.gz
# GeoLite City							http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
# GeoLite City IPv6 (Beta)	http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
# GeoLite ASN								http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
# GeoLite ASN IPv6 					http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz
#
#
# Tested on Ubuntu 16.04 LTS and Mac OS X 10.11.6

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
FOLDER_PATH="/opt/GeoIP"

# Check if folder exists
if [ -d ${FOLDER_PATH} ];then
	cd ${FOLDER_PATH}
else
	mkdir -p ${FOLDER_PATH}
	cd ${FOLDER_PATH}
fi

# Check if existing GeoIP Legacy binary databases are older than 30 days
# Note: The GeoLite databases are free IP geolocation databases. They are updated on the first Tuesday of each month.
if [ -f "${FOLDER_PATH}/GeoIP.dat" ];then
if test `find "${FOLDER_PATH}/GeoIP.dat" -mtime +30`;then
	echo "[Info]  Your existing GeoIP Legacy binary databases are older than 30 days and will be updated now!"
else
	echo "[Info]  Your existing GeoIP Legacy binary databases are NOT older than 30 days." && exit 1
fi
fi

# Check Internet Connection
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if ! [ $? -eq 0 ]; then
	echo "[Error]  Please check your internet connection!" && exit 1
fi

# Remove all files except 'geoipupdate.sh'
find . ! -name 'geoipupdate.sh' -type f -exec rm -f {} +

# Downloading GeoIP Legacy binary databases
echo -n "[Info]  Downloading GeoIP Legacy binary databases ... "
wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
wget -q http://geolite.maxmind.com/download/geoip/database/GeoIPv6.dat.gz
wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
wget -q http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
wget -q http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz
echo "[Done]"

# Extracting archive files
echo -n "[Info]  Extracting archive files ... "
gzip -d GeoIP.dat.gz
gzip -d GeoIPv6.dat.gz
gzip -d GeoLiteCity.dat.gz
gzip -d GeoLiteCityv6.dat.gz
gzip -d GeoIPASNum.dat.gz
gzip -d GeoIPASNumv6.dat.gz
echo "[Done]"
