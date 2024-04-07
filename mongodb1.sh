#!/bin/bash 
ID=$(id -u)
R="\[31m"
G="\[32m"
Y="\[33m"
N="\[0m"
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
echo "script started executing at $TIMESTAMP" >> $LOGFILE
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "COPYING REPO FILE"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling MONGOD"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "STARTING MONGOD"

sed -i "/s/127.0.0.1/0.0.0.0/g"  &>> $LOGFILE

VALIDATE $? "Replacing the content files"

systemctl restart mongod  &>> $LOGFILE

VALIDATE $? "Restarting the mongod"

