import csv
import os

hostNames = []
ipAddresses = []
username = 
password = 

with open('ip.csv') as csvDataFile:
    csvReader = csv.reader(csvDataFile)
    for row in csvReader:
        hostNames.append(row[0])
        ipAddresses.append(row[1])

inspecScan = "sudo inspec exec inspec-profile-disa_stig-el7/ --attrs=inspec-profile-disa_stig-el7/attributes.yml -t ssh://" + username + hostNames
    