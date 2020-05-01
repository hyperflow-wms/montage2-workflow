#!/usr/bin/env python2

import json
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('-p', '--path', help='path to workflow.json', default="workflow.json")
parser.add_argument('-n', '--name', help='name of workflow', default="soykb")
parser.add_argument('-s', '--size', help='size of workflow', default="")
parser.add_argument('-v', '--version', help='version of workflow', default="1.0.0")
args = parser.parse_args()

with open(args.path, "r") as file:
    contents = file.read()
wf = json.loads(contents)
wf["name"] = args.name
wf["version"] = args.version
if args.size:
    wf["size"] = args.size

with open(args.path, "w") as file:
    json.dump(wf, file, indent=4, sort_keys=True)