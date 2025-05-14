# More advanced workflows | intermediateML **(not finished)**

## Introduction
This readme helps the reader to understand the code of the *'intermediateML'* folder and is part of the larger brane tutorial. The goal is to create a slightly more advanced machine learning model with brane, to show the more advanced interplay between the framework and the python code. For this we are going to use two newly created python packages *'compute'* and *'visualization'* that both use python packages such as sklearn, matplotlib and seaborn. 

A more detailed explanation of the code will be given in the next section and some important brane related things will be outlined in the section after that.

## Explanation of the code
To run the workflow represented in the 'pipeline.bs' file, two packages will be created. 

### Compute package
The first is called the *'compute'* package and contains functions that handle the computations on the data. These are divided in preprocessing and model functions and can be found in the *'preprocessing.py'* and *'model.py'* file respectively. 

### Visualization package
The second package is called *'visualization'* and handels all visualizations of the results. The functions for this can be found in the file *'visualization.py'*. 

### Workflow
Using the above described packages, the *'pipeline.bs'* processes the data in several steps to finally come to the final result, which is a set of files that show several plots and processed datafiles. 

The first step is the cleaning of the two datasets (train and test) and uses the function *'clean'*. After that, the datasets are tokenized in step two, using the function *'tokenize'* and in step three the stop works are removed using the function *'remove_stopwords'*.
At this point we have two pre-processed datasets that will be used in the next step (step four) of the process to create the features using the function *'create_vectors'*. Step five performs the actual training of the model using the function *'train_model'*, step six generates bigrams using *'generate_bigrams'* and step seven creates classifications of tweets using *'create_submission'*.

Then we move to the next stage of the process, the visualization. Here, in step eight, the top bigrams are plotted using the function *'plot_bigrams_distribution'*. Them in step nine, the prediction plot is created using the function *'generate_prediction_plot'*, the location profile plot is created in step ten using *'generate_location_profile'*, the tweet profile plot is created in step eleven using *'generate_tweets_profile'*, the keyword profile plot is created in step twelve using *'generate_keywords_profile'* and finally an interative plot is created using the *'visualization_action'* function.

That concludes the ML process. All the results can be found in the */data* and/or */results* folder, where every step gets a separate folder. More information about the specific functions can be found in the docstring of that specific function.

## Implementation
1. For this example we are going to create a more advanced machine learning model. We are going to use pre-defined code and create two pacakges that will use text data and an nlp model to visualise the results
2. More background information about this example can be found in the readme of the folder *'intermediateML'*
  - If you want to dive in the brane part of this example, review the code and try to figure out how the python code interact with the brane code
  - To get you started, this readme provides some important things to know
3. First we are going to create the packages, which are called 'compute' and 'visualization':
  - Open the [controlVM] and move to the */brane* folder
  - Create new package folder | `mkdir compute` & `mkdir visualization`
  - Move back to the */strad-md-infra* folder
  - Copy files | 
    - `cp -r braneFiles/intermediateML/compute brane/compute`
    - `cp -r braneFiles/intermediateML/visualization brane/visualization`
  - Create package compute | 
    - Move to the *compute/* folder
    - Run `brane package build ./container.yml --init /usr/local/bin/branelet`
  - Create package visualization |
    - Move to the *visualization/* folder
    - Run `brane package build ./container.yml --init /usr/local/bin/branelet`
  - If these two commands run properly, you should be able to see the packages locally on the [controlVM] | `brane package list`
4. Define data :
  - Now we are going to create the data on the [controlVM] for testing purposes and on the [workerVM] for the actual workflow
  - You can explore the data by yourself. Both files are located in the *strad-md-infra/braneFiles/intermediateML/data/* folder
  - First we are going to make the data available on the [controlVM]. So move to the *strad-md-infra/* folder
    - Create train data | `brane data build ./braneFiles/intermediateML/data/train/data.yml` 
    - Create test data | `brane data build ./braneFiles/intermediateML/data/test/data.yml`
    - Make sure both data files are locally available | `brane data list`
  - Next we are going to make sure the data is available on the [workerVM] when we run a workflow
    - Move to the *brane/data* folder on the [workerVM]
    - Make folders | `mkdir nlp_train` & `mkdir nlp_test`
    - Move to the *strad-md-infra/* folder
    - Copy train files | `cp -r braneFiles/intermediateML/data/train brane/data/nlp_train`
    - Copy test files | `cp -r braneFiles/intermediateML/data/test brane/data/nlp_test`
5. Lets now test the newly created packages on the [controlVM]:
  - Test the compute package | `brane package test compute` and choose a function and one of the two previously created datasets
  - Test the visualization package | `brane package test visualization` and choose a function and one of the two previously created datasets
  - If this works without errors, the packages work properly and we are ready to use them in a workflow
6. Next, we are going to run a workflow to use the packages in practice:
  - When you investigate the workflow, which is called 'pipeline.bs', you can see how different functions are used to create intermediateResults for the next steps
  - Make sure that the name of your worker node matches the name defined in the 'on' statement in the workflow
  - If everything is prepared properly, running the workflow is as simple as using the command `brane workflow run ./pipeline.bs --remote`
  - If this works, congrats, you successfully ran a more complex machine learning flow in a federated setting using healthcare data!!:) Lets celebrate with a beer!
7. View results


## Important things
TBA

## Questions
For questions, contact Thijs at m.m.dieperink@umcutrecht.nl