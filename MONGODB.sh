#!/bin/bash 

ID=$(id -u)
if [ $ID -ne 0 ]
then 
    echo "Please login with root user"
    exit 1
else
    echo "You are the root user"
fi

