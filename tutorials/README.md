# Brane tutorials 

## Introduction
At the moment of writing, three examples are partly available and two are under construction. The *'hello_world'* example is complete and gives information about the inner working of the framework. The second example is called the *'average'* workflow and uses data locally and remotely and the last example is the *'minmax'* example, which will show how to use arguments, fucntions and the BraneScript concept of IntermediateResults (this last feature is not complete yet). I am working on the tutorials that are not finished and will update this readme regurarly.

The next sections assume that you have a working brane setup with instance ready to use. If this is not the case yet, go to the *'setup'* folder and choose one of the setups to implement. 

## Starting with packages
1. We start exploring the framework by working with a simple hello world package
2. But, before we can do anything with packages, we need to define a brane instance. So if you haven't selected a brane instance yet, perform the following steps:
    - Make sure all brane services (containers) are running properly in the worker and control node
    - Go to the control node and run | `brane instance add control.nl –name demoInstance`. This will create an instance called *demoInstance*
    - Then, run | `brane instance list` to show if your instance is created properly
    - Select instance to work with | `brane instance select demoInstance`
3.	To give a feeling on how to work with packages, we will create the most basic package there is. Let’s make a hello world package:
    - It is a good practice to read carefully through the brane documentation regarding the ‘hello world’ package (https://wiki.enablingpersonalizedinterventions.nl/user-guide/software-engineers/hello-world.html)
    - It gives information how to write this package and use it locally and remotely
    - Use your newly created instance *demoInstance* for this package
    - Important to know: branelet is installed differently than the framework expects, so you have to pass the correct executable to the brane package build command | `brane package build --init /usr/local/bin/branelet`
4.	If this all works fine, then you are ready to run your first workflow, lets continue in the next section.

## Starting with workflows
1.	In the previous section you already created, tested and ran your package remotely in the ‘repl’ mode. Now we are going to run this using a workflow
2.  Workflows are designed with BraneScript (bs), which is a workflow specification language. This means that the real work of any BraneScript file is not performed within the domain of BraneScript, but rather in the domain of the package functions that BraneScript calls. It only acts as a way to "glue" all these functions together and show the result(s) to the caller of the workflow. For more information about this language, see the references (documentation on this is not up-to-date)
3.	Creating the Branescript file:
    - Open the [controlVM] and go to the hello_world folder of your package, create a new file called *‘workflow.bs’*
    - Make sure that the package is pushed to the instance | `brane package search` and see if the hello_world package is available
    - Add the following code:
        Import hello_world;
        #[on(“workernode”)]
        {
            println(hello_world());
        }
    - Don’t forget the proper indentation
    - The "workernode" within the println statement is the name of the worker node
4.	Running the workflow | `brane workflow run ./workflow.bs --remote`
5.	If a ‘Hello World!’ message is printed to the terminal, congrats, you ran your first workflow!
6. This is just a simple workflow definition, but you can imagine that several packages can be used together to create a larger block of functionality in one bs file.

## Continue with more advanced workfows
Now that you have created and run your first package and workflow, you can move on to more complicated packages. As mentioned in the introduction, I created several of these in this folder. We have the average, minmax, basicML and intermediateML tutorials. The last two are not ready, so I suggest to start with average and then move to minmax. More information can be found in the readme of their specific folder. Good luck!
