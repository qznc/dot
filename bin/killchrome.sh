#!/bin/sh
set -e
PSLIST=$(ps ax | grep chrome | grep opt)
echo "psgrep gave:"
echo "$PSLIST"
PIDS=$(echo $PSLIST | cut -d " " -s -f 1)
echo "Killing $PIDS"
echo $PIDS | xargs kill -9
