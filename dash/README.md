# Pins + dash app on posit

## Important thing to know

### Pins:
1. To deploy a pin to Posit, you only need the pinsTest.py file
2. Make sure you change the API_KEY variable and the name of the pin
3. You can hardcore the first one, or use environment variables
4. For the latter, naming of a pin is very specific. You need to start with your umcu email, followed by a /namePin. Example: M.M.Dieperink@umcutrecht.nl/examplePinName. This is user specific, so fill in your own email
5. Run the script (pinsTest.py) from command line ( "python pinsTest.py") or IDE.
6. After step 5, data should be uploaded to PositConnect, you can check it from website. And you can start using these pins in your app.  

### Dash:
1. The app.py and requirement.txt files are necessary to deploy the simple dash app
2. For now it works via the terminal:
   - You need to install the rsconnect-python package | `pip install rsconnect`
   - Define a posit server conenction | `rsconnect add --server https://rsc.ds.umcutrecht.nl/ --api-key <API_KEY> --name <username>`
     - You can create the API_KEY in posit connect in the top right corner, under your profile it says "Manage your API Keys"
     - Check your role when you generate API_key, by default it is 'Viewer', you need 'Publisher' access to deploy your app. Request it from Content -> Publish (or send an email to analytics@umcutrecht.nl). 
     - The username is something you can define here, it is the internal name you use on Posit
   - Deploy the app | `rsconnect deploy dash . --entrypoint app:app --name thijsdieperink --title "Test dash app" --python $(pyenv which python)`
     - The "." indicates that the app is located in the currenct folder
     - The name is the username you defined when you created the server connection
     - Posit doesn't support the more recent python versions, so if you get a message saying something about your python version. Install version 3.10 using pyenv. This works for sure!

### What's next:
This code allows you to deploy pins and dash apps to posit from your command line. 
A next step to explore would be to deploy both entities using GitLab and Jenkins.

## References
1. General UMCU docs | https://umcutrecht.sharepoint.com/sites/TOPIC_Servicecenter/SitePages/Posit-Connect.aspx
2. Posit UMCU docs | https://rsc.ds.umcutrecht.nl/documentatie/posit-documentation.html#python-applicaties
3. Posit docs | https://rsc.ds.umcutrecht.nl/__docs__/user/