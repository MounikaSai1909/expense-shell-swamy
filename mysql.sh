#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "please enter DB password"
read -s mysql_root_password

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
   echo " You are a super user "
else
    echo " Please run this script with root access"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idemponent nature
mysql -h db.swamy.fun -uroot -pExpenseApp@1 -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -eq 0 ]
then
   echo -e "MYSQL root password is already setup.. $Y SKIPPING $N"
else
   mysql_secure_installation --set-root-pass ${mysql_root_password}  &>>$LOGFILE
   VALIDATE $? "MySQL root password setup"
fi
  
   