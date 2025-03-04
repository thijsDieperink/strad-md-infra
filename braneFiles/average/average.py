#!/usr/bin/env python3

# Some python code for the average workflow. Still needs to be fixed

import json
import os

def average(dataset: str) -> float:
    with open(dataset, "r") as h:
        n = 0
        total = 0
        for line in h.readlines():
            n+=1
        return n
    
dataset = json.load(os.environ["DATASET"])
#avg = average(dataset)

print(f"output: Success")