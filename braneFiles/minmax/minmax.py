#!/usr/bin/env python3

import json
import os
import pandas as pd
import sys

def max(column: int, df: pd.DataFrame) -> int:
    return df.max(axis=column)

def min(column: int, df: pd.DataFrame) -> int:
    return df.min(axis=column)

if __name__ == "__main__":
    column = json.loads(os.environ["COLUMN"])
    file = json.loads(os.environ["FILE"])
    df = pd.read_csv(file)

    command = sys.argv[1]
    if command == "max":
        result = max(column, df)
    else:
        result = min(column, df)

    # Print the output as a int
    print(f"output: {result}")