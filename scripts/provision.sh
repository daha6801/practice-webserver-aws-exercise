#!/bin/bash


function setup_webserver() {
	sudo yum update -y
	sudo amazon-linux-extras install nginx1.12 -y
	sudo chkconfig nginx on
	sudo aws s3 cp s3://daha6801-assignment-webserver/index.html /usr/share/nginx/html/index.html
	sudo service nginx start
	curl http://169.254.169.254/latest/meta-data/
}

ACTION=${1:-launch}
version=1.0.0

function show_version() {
echo "$version"
}

function display_help() {
cat << EOF
Usage: ${0} {-r|--remove|-h|--help|-v|--version} <filename>
OPTIONS:
-r | --remove Removes webserver from the system
-v | --version Show the script version
-h | --help Display the command help
Examples:
Remove webserver from the system:
$ ${0} -r
Show the script version:
$ ${0} -v
Display help:
$ ${0} -h
EOF
}

function remove_webserver() {
        sudo service nginx stop
        sudo rm -rf /usr/share/nginx/html
        sudo yum remove nginx -y
}

if [ -z "$1" ]
then 
	echo "No argument supplied, default action is : $ACTION"
	setup_webserver
else
	echo "Initiating $ACTION."
	case "$ACTION" in
                -h|--help)
                display_help
        ;;
                -r|--remove)
                remove_webserver
        ;;
                -v|--version)
                show_version
        ;;
	*)
	echo "Usage ${0} {-r|-v|-h}"
	exit 1
	esac
fi

