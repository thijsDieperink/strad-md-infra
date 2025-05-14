# Brane setups 

## Introduction
In this folder you can start creating a brane system. There are several scenarios depending on your local setup and the complexity you are looking for. Because I automated a lot with automation scripts, we can define three main setups:
1. basicLocal | this is the simplest setup and will install a control-worker system on your local laptop. It is supported for mac, ubuntu and windows (under construction)
2. basicVBox | this is a control-worker system, but then installed on two different VirtualBox VMs. The goal of this setup is to mimic a more realistic setup. Currently, mac os intel, windows and ubuntu are supported and macos M is under construction
3. proxyVBox | this is a more complex system using a brane proxy service in a control-worker system. Currently, mac os intel, windows and ubuntu are supported and macos M is under construction

All of the above setups are explained in more detail in the readme of their specific folder. When you want to quickly start developing with brane, I suggest to create the basicLocal setup. When you want to investigate the infrastructural components of brane and how they communicate in a more realistic setting, go to the basicVBox setup. Lastly, when you want to investigate how brane communication works with a proxy, start with the proxyVBox setup. Good luck implementing!