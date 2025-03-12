#!/usr/bin/env python3

# Some python code for the average workflow. Still needs to be fixed

import json
import os

dataset = json.load(os.environ["DATASET"])
with open(dataset, "r") as file:
    n = 0
    tot = 0
    for line in file:
        val = int(line.strip())
        n+=1
        tot+=val
    avg = tot/n

print(f"output: {avg}")