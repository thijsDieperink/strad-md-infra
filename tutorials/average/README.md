# More advanced workflows | average

# Implementation
1. For this example we are going to write a workflow that calculates an average from a list of numbers
2. First we will create the datafile:
   - This dataset wil be used for local testing
   - Open the [controlVM] and make sure you are in the */strad-md-infra/brane* folder
   - Create a folder for your new package | `mkdir average` 
   - Move back to the /strad-md-infra folder | `cd ..`
   - Copy the data | `cp braneFiles/average/data brane/average` and investigate the content of the numbers.csv file
   - Move to the data folder of your package | `cd brane/average/data`
   - Build the data | `brane data build ./data.yml`
   - Check if the data is available on the instance | `brane data list`
3. Secondly, we will create and push a new package:
   - Create package files:
     - Go to the *strad-md-infra* folder
     - Run | `cp braneFiles/average/average.py brane/average`
     - Run | `cp braneFiles/average/container.yml brane/average`
     - Go back to the average folder in the brane repo | `cd brane/average` and investigate the content of the average.py and container.yml file
     - Build package | `brane package build ./container.yml --init /usr/local/bin/branelet`
     - Test package locally | `brane package test average`
       - When you run the last command, you will be asked to choose a dataset. Look for numbers and press enter as hard as you can!
   - Something important to note: untill now, we only used data from the control node for local testing. In the next step, we are going to create a datafile on the worker node as well that differs from the datafile on the control node. In this way, we can see what file is used for execution of the workflow
4. Data from worker node
   - Create datafile on the worker node:
     - Open the [workerVM] and make sure you are located in the *strad-md-infra* folder
     - Create new data folder | `mkdir /brane/data/numbers`
     - Copy data config to new folder | `cp braneFiles/average/data/data.yml brane/data/numbers`
     - Go to new folder | `cd brane/data/numbers`
     - Create new data file | `seq 20 29 > numbers.csv`, this file has a different content than our datafile on the control node
   - Make package available on the instance
     - Go to the [controlVM]
     - Push package to instance | `brane package push average`
     - Check if package is available on the instance | `brane package search`
   - Lastly, we will create and run the workflow:
     - Go to the */strad-md-infra* folder
     - Copy the workflow | `cp braneFiles/average/workflow.bs brane/average`
     - Move to the average folder | `cd brane/average` and investigate the content of the workflow.bs file
     - Run the workflow | `brane workflow run ./workflow.bs --remote`
5. Congrats!! That was your first workflow with data from the worker node. As you can imagine, you can theoretically set up several worker node and create code that runs on both environments. You can even specifically assign specific execution to specific workers. 
6. In the next example we are going to look at a slightly more complicated example in which we will use two functions, arguments, an extra input variable and intermediate results

## Important things
TBA