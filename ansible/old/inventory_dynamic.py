#!/usr/bin/env python

import sys
import json

if __name__ == "__main__":
	if len (sys.argv) == 2:
		if (sys.argv[1] == '--list'):
			with open("inventory.json", "r") as read_file:
				data = json.load(read_file)

			appIpExt = data['app']['hosts']['appserver']['ansible_host']
			dbIpExt = data['db']['hosts']['dbserver']['ansible_host']

			jsonString = """{
   "app": {
        "hosts": [\"""" + appIpExt + """\"]
    },
   "db": {
        "hosts": [\"""" + dbIpExt + """\"]
    },
    "_meta": {
        "hostvars": {}
    }
}"""
			
			print(jsonString)
#			print(appIpExt)
#			print(dbIpExt)
		if (sys.argv[1] == '--host'):
			print("{\"_meta\": {\"hostvars\": {}}}")
	else:
		print("{ }")

