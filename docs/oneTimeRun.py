import csv
import os
from datetime import date


today = date.today()
currentPath = os.getcwd()
hostNames = []
ipAddresses = []
username = input("What is the username for this machine(s)?")
password = input("What is the password for this service account?")
scanType = input("How would you like to run this scan, via host name or via ip address?")
nameOfFile = input("What is the name of your csv file where your hostname and IP addresses are stored?")

with open(nameOfFile) as csvDataFile:
    csvReader = csv.reader(csvDataFile)
    for row in csvReader:
        hostNames.append(row[0])
        ipAddresses.append(row[1])

if (scanType == "host name" or scanType =="hostname" or scanType =="Host name" or scanType =="Hostname"):
    for hostName in hostNames:    
        inspecScan = "sudo inspec exec inspec-profile-disa_stig-el7/ --attrs=inspec-profile-disa_stig-el7/attributes.yml -t ssh://" + username + "@" + hostName + " --sudo --sudo-password=" + password + " --password=" + password + " --reporter cli json:" + currentPath + hostName + "-" + str(today) + ".json"
        os.system(inspecScan)
elif (scanType == "ip address" or scanType =="ipaddress" or scanType =="Ip Address" or scanType =="IP Address" or scanType =="IP address"):
    for ipAddress in ipAddresses:
        inspecScan = "sudo inspec exec inspec-profile-disa_stig-el7/ --attrs=inspec-profile-disa_stig-el7/attributes.yml -t ssh://" + username + "@" + ipAddress + " --sudo --sudo-password=" + password + " --password=" + password + " --reporter cli json:" + currentPath + ipAddress + "-" + str(today) + ".json"
        os.system(inspecScan)
else:
    scanType = input("How would you like to run this scan, via host name or via ip address?")