# More advanced workflows | minmax w intermediate results (**not finished**)

## Implementation
1. For this example we are going to write a workflow that calculates the min or max function from a list of numbers
2. First, we will create, push and test a new package:
   - Create package files:
     - Open the [controlVM] and make sure you are in the */strad-md-infra* folder
     - Copy the entire minmax folder | `cp -r braneFiles/minmax brane/minmax`
     - Go back to the minmax folder in the brane repo | `cd brane/minmax` and investigate the content of the minmax.py and container.yml file
   - Build package | `brane package build ./container.yml --init /usr/local/bin/branelet`
   - Test package locally | `brane package test minmax`
     - When you run the last command, you will first be asked to choose an argument, min or max (choose yourself), a column (choose 0) and a dataset. Look for numbers and press enter as hard as you can!
3. Running the workflow:
   - Now we will run workflow remotely using the workflow.bs file. First investigate this file and notice how the min and max function are called
   - Run workflow | `brane workflow run ./workflow.bs --remote`
4. If the previous workflow runs smoothly, we are going to switch up our output gears. That means, we are going to write the output of our workflow to a file, instead of to the command line.
   - **TBA**

## Important things