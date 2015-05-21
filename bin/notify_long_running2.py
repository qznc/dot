#!/usr/bin/env python3

import sys
import notify2
import datetime

MINIMUM_SECONDS = 30

def maybe_notify(duration, cmd):
	seconds = duration.total_seconds()
	if (seconds < MINIMUM_SECONDS):
		return
	summary = "Finished after "+str(duration)
	notify2.init("undistract my fish")
	n = notify2.Notification(summary, cmd, "face-surprise")
	n.set_hint_int32("transient", 1)
	n.show()

def parse_iso8601(datestr):
	return datetime.datetime.strptime(datestr, "%Y-%m-%dT%H:%M:%S%z" )

if __name__ == "__main__":
	if len(sys.argv) != 4:
		print("wrong usage:", sys.argv[0])
		exit(1)
	me,start,end,cmd = sys.argv
	duration = parse_iso8601(end) - parse_iso8601(start)
	maybe_notify(duration,cmd)
