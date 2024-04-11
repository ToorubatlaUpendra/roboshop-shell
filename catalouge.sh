#!/bin/bash
ID=$(id -u)
R="\[m31"
Y="\[m32"
G="\[m33"
N="\[m0"
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

id roboshop 

if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "USER creation is"
else 
    echo "USER already exsists"
fi

