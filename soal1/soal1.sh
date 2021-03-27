#!/bin/bash

#1a
grep -o "[I|E].*" syslog.log

#1b
grep -o "ERROR.*" syslog.log | cut -d "(" -f1 | sort | uniq -c

#1c
grep -o "ERROR.*" syslog.log | cut -d "(" -f2 | cut -d ")" -f1 | sort | uniq -c
grep -o "INFO.*" syslog.log | cut -d "(" -f2 | cut -d ")" -f1 | sort | uniq -c

#1d
modified=$(grep "modified" syslog.log | wc -l)
permission=$(grep "Permission" syslog.log | wc -l)
tried=$(grep "Tried" syslog.log | wc -l)
timeout=$(grep "Timeout" syslog.log | wc -l)
exist=$(grep "exist" syslog.log | wc -l)
connection=$(grep "Connection" syslog.log | wc -l)

echo "Error,Count" > error_message.csv

printf "Permission denied,%d\n
The ticket was modified while updating,%d\n
Tried to add information to closed ticket,%d\n
Timeout while retrieving information,%d\n
Ticket doesn't exist,%d\n
Connection to DB failed,%d\n" $modified $permission $tried $timeout $exist $connection |
sort -t"," -k2 -nr  >> error_message.csv

#1e
echo "Username,Info,Error" > user_statistic.csv
 
cut -d "(" -f2 syslog.log | cut -d ")" -f1 | sort | uniq |
while read line;
do
  e=$(grep -o "ERROR.*($line)" syslog.log | wc -l)
  i=$(grep -o "INFO.*($line)" syslog.log | wc -l)
  echo -e "$line,$i,$e"
done >> user_statistic.csv


