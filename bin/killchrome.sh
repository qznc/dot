#!/bin/sh
set -e

function getpid() {
	PSLIST=$(ps ax | grep chrome | grep opt)
	PID=$(echo $PSLIST | cut -d " " -s -f 1)
	echo "$PID"
}

PID=$(getpid)
while [ $PID ]
do
	echo "Killing $PID"
	PID=$(getpid)
	kill -9 $PID
done
