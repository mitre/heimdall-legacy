# Single time run

**YOU MUST RUN THIS AS SUDO, EX: ```$ sudo python3 oneTimeRun.py```**

* You can run this scan if you are not automating it. This will allow you to set the username and password of the boxes you wish to scan.
* Set the scan type as ip address or hostname, this will select whether it will scan the hosts by IP address or by hostname, sometimes you
do not have hostnames readily available.
* You will be prompted for the path of the csv file. In this CSV file, you **MUST** point to the absolute path of where the CSV file is located. 
* CSV Files **MUST** be formatted in hostname,ipaddress format. The file will be parsed incorrectly if you do not do it this way.
* The JSON files will be saved in the currect working directory, if you don't know where that is, you can run ```$ pwd``` The scan will be placed there.
* Use Heimdall or Heimdall-lite to view the results.

* **THIS SCAN IS FOR LINUX SCANS ONLY**
