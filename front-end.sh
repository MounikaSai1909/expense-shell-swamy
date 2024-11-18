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
   echo "You are a super user"
else
    echo "Please run this script with root access"
fi


dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx
VALIDATE $? "Enabling nginx"

systemctl start nginx
VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing the existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "Downloading front end code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip
VALIDATE $? "Extracting frontend code"

cp /home/ec2-user/expense-shell-swamy/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "copying the expense conf file"

systemctl restart nginx
VALIDATE $? "Restarting nginx"
