#!/bin/sh
set -e
ps ax | grep chrome | grep opt | cut -d " " -f 1 | xargs kill -9
