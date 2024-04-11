#!/bin/bash
ID=$(id -u)
R="\e[31m"
Y="\e[32m"
G="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "script started executing" &>>$LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf module disable nodejs -y &>>$LOGFILE 

VALIDATE $? "DISABLE NODEJS" 

dnf module enable nodejs:18 -y &>>$LOGFILE 

VALIDATE $? "Enable NODEJS 18" 

dnf install nodejs -y &>>$LOGFILE

VALIDATE $? "NodeJs installation" 


id roboshop 

if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "USER creation is"
else 
    echo "USER already exsists"
fi

mkdir -p /app &>>$LOGFILE

VALIDATE $? "Directory created" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "catlouge file download" 

cd /app &>>$LOGFILE

VALIDATE $? "change directory"

unzip -o /tmp/catalogue.zip  &>>$LOGFILE

VALIDATE $? "unzip"

cd /app &>>$LOGFILE

VALIDATE $? "change directory"

npm install &>>$LOGFILE

VALIDATE $? "npm install"

cp /root/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copying service file"

systemctl daemon-reload

VALIDATE $? "reloading"

systemctl enable catalogue

VALIDATE $? "enabiling"

systemctl start catalogue

VALIDATE $? "start catalouge"

cp mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying repo file"


dnf install mongodb-org-shell -y

VALIDATE $? "installing mongo client"


mongo --host 54.159.178.138 </app/schema/catalogue.js

VALIDATE $? "moving files to mongo db "




