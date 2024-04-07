#!/bin/bash 

ID=$(id -u)
# PACKAGE=$1
NAME_REPO="MongoDB Repository"
BASEURL="https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/"
VERSION="[mongodb-org-4.2]"
PATH_FILE="/etc/yum.repos.d/mongo.repo"
CONTENT_FILE="$VERSION
name=MongoDB Repository
baseurl=$BASEURL
gpgcheck=0
enabled=1"
echo "$CONTENT_FILE" > $PATH_FILE
if [ $ID -ne 0 ]
then 
    echo "Please login with root user"
    exit 1
else
    echo "You are the root user"
fi

rpm -q "mongodb"
if [ $? -ne 0]
then
    dnf install mongodb-org -y 
else 
    echo "package is already installed"
fi
    
