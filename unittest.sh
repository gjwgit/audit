#!/bin/bash

MODEL="audit"

date +"%Y-%m-%d %H:%M:%S"

time /usr/bin/expect <<EOD
set timeout 60

spawn ml install ${MODEL}
expect "*${MODEL}*Y/n*"
send "Y\n"
expect eof

spawn ml readme ${MODEL}
expect eof

spawn ml configure ${MODEL}
expect eof

spawn ml demo ${MODEL}
expect "Press Enter to continue on to a Confusion Matrix: "
send "\n"
expect "Press Enter to continue on to a Risk Chart: "
send "\n"
expect "Press Enter to finish the demonstration: "
send "\n"
expect eof

EOD

echo
ls -lht ~/.mlhub/${MODEL}/audit_rpart_riskchart.pdf
echo
date +"%Y-%m-%d %H:%M:%S"
