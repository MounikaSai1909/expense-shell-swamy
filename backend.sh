#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE(){
    if [ $1 -eq 0 ]
    then 
       echo -e " $2.. $G SUCCESS $N"
    else
       echo -e "$2.. $R FAILURE $N"  
    fi
} 

if [ $USERID -eq 0 ]
then
   echo "You are a super user "
else
    echo "Please run this script with root access"
fi


dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "disabling default node js"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabling node js: 20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing node js"

# useradd expense
# VALIDATE $? "Creating expense user"

id expense
if [ $? -eq 0 ]
then 
   echo -e " Expense user already exists... $Y SKIPPING $N"
else 
    useradd expense
    VALIDATE $? " Creating expense user "
fi
    



