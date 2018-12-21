#!/bin/bash

MODEL="audit"

/usr/bin/expect <<EOD
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

ls -lh ~/.mlhub/${MODEL}/audit_rpart_riskchart.pdf


