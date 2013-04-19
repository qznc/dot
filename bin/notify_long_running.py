#!/usr/bin/env python3

import sys
import notify2

MINIMUM_SECONDS = 30

def parse_duration(string):
	seconds = 0.0
	string = string.strip().replace(",", ".")
	if not string:
		return 0
	elif string.endswith("h"):
		seconds = float(string[:-1]) * 60 * 60
	elif "m" in string:
		m,s = string.split()
		seconds = float(s[:-1])
		seconds += float(m[:-1]) * 60
	else:
		seconds = float(string[:-1])
	return int(seconds+0.5)

assert parse_duration("12.345s") == 12
assert parse_duration("2.7345s") == 3
assert parse_duration("2m 3.5s") == 2*60+4
assert parse_duration("70m 5s") == 70*60+5
assert parse_duration("1.2h") == int(60*60*1.2)

def maybe_notify(duration, cmd):
	seconds = parse_duration(duration)
	if (seconds < MINIMUM_SECONDS):
		return
	summary = "Finished after "+duration
	notify2.init("undistract my fish")
	n = notify2.Notification(summary, cmd, "face-surprise")
	n.show()

if __name__ == "__main__":
	try:
		duration = sys.argv[1]
	except IndexError:
		duration = "0s"
	try:
		cmd = sys.argv[2]
	except IndexError:
		cmd = "?"
	maybe_notify(duration, cmd)
