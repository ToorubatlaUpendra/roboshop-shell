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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "downloading remi" 

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "enablining redis" 

dnf install redis -y &>> $LOGFILE

VALIDATE $? "installing redis" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf  &>> $LOGFILE

VALIDATE $? "Replacing with public ip" 

systemctl enable redis &>> $LOGFILE

VALIDATE $? "enabling redis" 


systemctl start redis &>> $LOGFILE 

VALIDATE $? "starting redis" 


