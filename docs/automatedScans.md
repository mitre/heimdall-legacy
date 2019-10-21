# Automated script

* Create a config file where the profile you want to run is located, such as /path/to/profile/config.sh

* Once the config is created, inside of the profile create two variables as such

``` username = insertUsernameHere ```
``` password = insertPasswordHere ```

* Close and save the file, and then change the privelages of the file by running ```sudo chmod 700 config.sh```

* Now open the automatedScan.sh provided in the heimdall/docs directory, open the file

* Upon opening the file, make sure you uncomment the source line and put the absolute path to your config.sh you just created above. You can figure out where that 
is by running ```$ pwd ``` in the directory

* In both of the inspec commands, one for windows and one for linux, go ahead and **REMOVE** the brackets and **EDIT** the placeholders with absolute paths that 
point to the profile and where the scan will be saved. 

* Repeat the above step for as many hosts you need to scan, but modify the hostname and name of .json files

* Once you have saved the file, go ahead and create a new cronjob using ```sudo crontab -e``` 

**EXAMPLE** ```0 2 * * 5 /path/to/automatedScan.sh``` 

The above example will run the scan every Friday at 2 AM as root. **This will not work if you do not run this script as Root, since config.sh requires root to read**