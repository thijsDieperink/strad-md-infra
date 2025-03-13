#!/usr/bin/env python3

import json
import os
import pandas as pd
import sys

# define function 'max' that calculates the max of a dataframe
def max(column: int, df: pd.DataFrame) -> int:
    return df.max(axis=column)

# define function 'min' that calculates the min of a dataframe
def min(column: int, df: pd.DataFrame) -> int:
    return df.min(axis=column)

if __name__ == "__main__":
    # load the variable 'column' as defined in the container.yml file
    column = json.loads(os.environ["COLUMN"])
    # load the data with name "file" as defined in the container.yml file
    file = json.loads(os.environ["FILE"])
    df = pd.read_csv(file)

    # assign the second argument to the 'command' variable
    command = sys.argv[1]
    if command == "max":
        result = max(column, df).iloc[0]
    else:
        result = min(column, df).iloc[0]

    # print 'output' variable as defined in the container.yml file (int)
    print(f"output: {result}")