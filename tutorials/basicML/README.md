# Readme basicML code **(not finished)**

## Introduction
This readme helps the reader to understand the code of the *'basicML'* folder and is part of the larger brane tutorial. The goal is to create a very minimal machine learning model with brane to show how the interaction between the framework and the python code works. For this we are going to use the python package sklearn. For a more detailed example, explore the *'intermediateML'* folder.

## Explanation of the code 
For this example, the sklearn build-in dataset about breast cancer is used. This dataset is already pre-processed so no missing values exist and it only contains numerical columns. Using the StandardScalar function the numerical features are scaled so that they have a mean of 0 and a standard deviation of 1.

We are going to use a Logistic Regression with the accuracy, precision, recall, F1 score and confusion matrix. The results are displayed in a classification report and written to a file called *'results.txt'*. The confusion matrix is also plotted and written to the *'confusion_matrix.png'* file.

Open these two newly created files to view your results.

## Important things
TBA

## Questions
For questions, contact Thijs at m.m.dieperink@umcutrecht.nl