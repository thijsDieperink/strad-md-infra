#!/usr/bin/env python3

import json
import os

# load the data with name "dataset" as defined in the container.yml file
dataset = json.loads(os.environ["DATASET"])
# open data and calculate average
with open(dataset, "r") as file:
    n = 0
    tot = 0
    for line in file:

        val = int(line.strip())
        n+=1
        tot+=val
    avg = tot/n

# print 'output' variable as defined in the container.yml file (real or float)
print(f"output: {avg}")