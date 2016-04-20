#!/bin/bash

REQUIREMENT="docker"
PACKAGE="coherent/nginx"
VER="1.0.0"
IMAGENAME="nginx"
APP_PATH="$(cd "$(dirname "$2")/$(basename "$2")" && pwd -P)"

command -v $REQUIREMENT >/dev/null 2>&1 || { 
  echo >&2 "I require $REQUIREMENT but it's not installed. Please refer to https://docs.docker.com/toolbox/overview/";
  echo >&2 "Aborting."; exit 1; 
}

echo "";
echo '-- Starting '$IMAGENAME' image build of '$PACKAGE:$VER' -- '
echo "";
echo "-- Scanning for VBox VM instances -- use one of these to direct requests to for testing";
echo "";
docker-machine ls | grep unning;
echo "";
echo "-- Scanning for VBox VM IPs -- use this to verify matching IP from above list";
echo "";
arp -n -i vboxnet0 -l -a;
arp -n -i vboxnet1 -l -a;
echo "";
DIR=$( cd "$( dirname "$0" )" && pwd )

docker pull nginx 

if [[ $? == 0 && $1 == "run" ]]; then 
  if [[ $2 == "" ]]; then
    echo 'you must include the application path for the index.html file when using the `run` option'
    echo 'USAGE:  ./nginx/prepare.sh run PATH/TO/WEBAPP/ROOT'
    exit 1
  fi
  sleep 2
  docker rm -f $IMAGENAME 2>&1 >/dev/null
  docker run --name $IMAGENAME -p 80:80 -d -v $APP_PATH:/usr/share/nginx/html nginx
  echo "";
  docker ps -a 2>&1
  echo "";
fi

exit 0