# strad-md-infra
*Updated: 12-02-2024*

## Introduction
Welcome to the brane tutorial for local development. If you want to learn the basics of brane and create your first package and workflow, you have come to the right place. We are first going to install two VMs on your local device with VirtualBox, then we are going to setup the worker node and control node. Thirdly, there are some last configurations that need to be performed to make everything communicate properly. Ater this, you are ready to start working with brane. 

At the moment of writing, three examples are partly available. The *'hello_world'* example is complete and gives information about the inner working of the framework. The second example is called the *'average'* workflow and uses data locally and remotely and the last example is the *'minmax'* example, which will show how to use arguments, fucntions and the BraneScript concept of IntermediateResults (this last one is not complete yet).

I am working on the things that are not finished yet and will update this tutorial regurarly.

Lastly, I know it is quite long and contains several steps, but just take your time and make sure that every step works properly. I included some tests here and there to help with this. Good luck and let me know if you have questions!!!

Ps: This code is available on two locations, the psydata gitlab page and my own github page. This is because you can only clone the code from gitlab when you are on the UMCU-INTERN wifi or activate JAMF Trust. So, if this is the case, use the gitlab url, otherwise use the url from my public github page. In the documentation below, I included the github url, but both are available in the references.

Pss: Theoretically, this tutorial can be used on every device that has a x86_64 cpu architecture. Most devices do have this, bu to make sure if your device qualifies for this, run `uname -m` on mac and linux and `echo %PROCESSOR_ARCHITECTURE` on windows.

## Setting up the environment

## Preparing the worker node

## Preparing the control node

## Last preparation, starting the nodes and testing

## Some last sort of good things to know


## Starting with packages

## Starting with workflows


## More advanced workflows | average

## More advanced workflows | minmax w intermediate results (**not finished**)

## More advanced workflows | basicML **(not finished)**

## More advanced workflows | intermediateML **(not finished)**

<<Add:
 - different use between gilab and github>>

## References
Installation:
1. Virtual Box download | https://www.virtualbox.org/wiki/Downloads
2. Virtual Box general | https://www.virtualbox.org/manual/ch01.html
3. Virtual Box networking | https://www.virtualbox.org/manual/ch06.html
4. Ubuntu ISO image | https://ubuntu.com/download/desktop
5. GitLab repo | https://gitlab.op.umcutrecht.nl/PsyData/strad/strad-md-infra
6. GitHub repo | https://github.com/thijsDieperink/strad-md-infra

Brane (not all documentation is up-to-date): 

7. Brane User guide | https://wiki.enablingpersonalizedinterventions.nl/user-guide/welcome.html
8. General brane | https://wiki.enablingpersonalizedinterventions.nl/specification/overview.html
9. Brane tutorials | https://wiki.enablingpersonalizedinterventions.nl/tutorials/welcome.html
10. Hello-world package brane | https://wiki.enablingpersonalizedinterventions.nl/user-guide/software-engineers/hello-world.html
11. BraneScript | https://wiki.enablingpersonalizedinterventions.nl/user-guide/branescript/introduction.html

Other:

12. Scp | https://www.geeksforgeeks.org/scp-command-in-linux-with-examples/

## Contributing
If you want to contribute to the code in some way, git clone the repo, create a branch, work on the code and open a merge request with me as a reviewer.

## Questions
For question, send a message to Thijs via Teams of email. 