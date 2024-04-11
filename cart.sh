#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "ERROR:: $2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}
echo "script started executing at $TIMESTAMP" &>> $LOGFILE
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf module disable nodejs -y

VALIDATE $? "disbale nodejs"

dnf module enable nodejs:18 -y

VALIDATE $? "enable nodejs"

dnf install nodejs -y

VALIDATE $? "install nodejs"

id roboshop 

if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "USER creation is"
else 
    echo "USER already exsists"
fi

mkdir -p /app

VALIDATE $? "directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip

VALIDATE $? "downoading"

cd /app 

unzip -o /tmp/cart.zip

VALIDATE $? "unzipping"

cd /app 

npm install 

VALIDATE $? "installation"

cp /root/roboshop-shell/user.service /etc/systemd/system/cart.service

VALIDATE $? "copying"

systemctl daemon-reload

VALIDATE $? "installation"


systemctl enable cart 

VALIDATE $? "installation"


systemctl start cart 

VALIDATE $? "start"

