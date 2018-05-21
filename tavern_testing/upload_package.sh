#!/bin/bash

PKG=""
URL=""
usage="\nTo use this script you must specify the following options:\n\n-p: path to the package\n-u: url to the api \n\nExample:\n\nsh upload_pkg.sh -p '/path/pkg_name.son' -u 'http://destination_url:32001/api/v2/packages'\n"

#read the arguments and save them in the variables
while getopts ":p:u:" option; do
    case "${option}" in
        p) PKG=${OPTARG};;
        u) URL=${OPTARG};;
        :) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
	*) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
   	\?) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    esac
done

if [ ! "$PKG" ] || [ ! "$URL" ]
then
    echo $usage
    exit 1
fi




LOGIN_URI=$(echo $URL | cut -d':' -f1-2)


LOGIN_URL="$LOGIN_URI:32001/api/v2/sessions"




echo
echo These are your options:
echo

echo Package: "\033[33;33m $PKG"
echo "\033[33;37m"
echo API URL: "\033[33;33m $URL"
echo
echo "\033[33;37mPress Enter to continue or CTRL+C to cancel "
read enter
echo "\033[33;32m...Retrieving login data and Reading Package Content..."
echo 


resp=$(curl -qSfsw '\n%{http_code}' -d '{"username":"sonata","password":"1234"}' ""$LOGIN_URL"")
token=$(printf "$resp" | grep -Po 'access_token":"\K[^"]+')


echo "\033[33;37m"
echo "Done"
sleep 2
echo
echo This is your TOKEN: "\033[33;33m$token "
echo
echo
echo "\033[33;32m...Uploading package..."
echo "\033[33;37m"
sleep 2

Result=$(curl -v -i -X POST -H "Authorization:Bearer $token" -F ""package=@$PKG"" ""$URL"")


created_at="created_at"

if echo "$Result" | grep "$created_at"
then
  echo
  echo "\033[33;33mPackage uploaded correctly"
  echo

uuid=$(printf "$Result" | grep -Po 'uuid":"\K[^"]+')

UUID_FINAL=$(echo $uuid| cut -d' ' -f 1)
echo "\033[33;37m"
echo "UUID = \033[33;32m $UUID_FINAL"
son_package_uuid=$(echo $uuid| cut -d' ' -f 2)
echo "\033[33;37m" 
echo "SON PACKAGE UUID = \033[33;32m $son_package_uuid"  
echo "\033[33;37m"
vendor=$(printf "$Result" | grep -Po 'vendor":"\K[^"]+')
echo "VENDOR = \033[33;32m $vendor" 
echo "\033[33;37m"
status=$(printf "$Result" | grep -Po 'status":"\K[^"]+')
echo "STATUS = \033[33;32m $status" 


  echo
  echo "\033[33;33mMessage sended to the Message Broker"
  MSG=$(tavern-ci mqqt.yml)
  echo 
  echo
else
  echo
  echo
  echo "ERROR UPLOADING THE PACKAGE:"
  echo
  echo "\033[33;33m $Result"
  echo "\033[33;37m"
  echo
fi





