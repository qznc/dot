#!/usr/bin/env python3

import sys
import notify2
import datetime

MINIMUM_SECONDS = 10

def maybe_notify(duration, cmd, success):
	seconds = duration.total_seconds()
	if (seconds < MINIMUM_SECONDS):
		return
	finished = ["Failed", "Succeeded"][success]
	summary = finished+" after "+str(duration)
	notify2.init("undistract my fish")
	n = notify2.Notification(summary, cmd, "face-surprise")
	n.set_hint_int32("transient", 1)
	n.set_timeout(60000)
	n.show()

def parse_iso8601(datestr):
	if len(datestr) > 22 and datestr[22] == ':':
		# remove colon in timezone for strptime
		datestr = datestr[:22] + datestr[23:]
	return datetime.datetime.strptime(datestr, "%Y-%m-%dT%H:%M:%S%z" )

if __name__ == "__main__":
	if len(sys.argv) != 5:
		print("wrong usage:", sys.argv[0])
		exit(1)
	me,start,end,cmd,status = sys.argv
	duration = parse_iso8601(end) - parse_iso8601(start)
	maybe_notify(duration,cmd,status=="0")
