#!/bin/bash

#The csv file
datafile="/somedir/somefile.csv"
#Get the headers
headers=$(head -1 ${datafile})
#Get the data by removing the headers using grep -v
myrecords=$(grep -v date ${datafile})

#Loop through the data line by line
for i in $(echo ${myrecords}); do
	#Get the date and convert to EPOCH time (assuming the date field is field 1)
  starting=$(date --date="$(echo $i | awk -F , {'print $1'} | xargs -I {} echo "{}")" +%s)
  #Loop through each field (date was field 1 so we start with 2 and
  #loop through 31 since for this file, there are 31 fields)
  #although, we should just count the number of fields and dynamicaly update the field number
  #next version :)
  for x in {2..31};do
    #Grab the field and remove the double paranthesis using sed
    myfield=$(echo $headers | awk -F , -v thefield=$x '{print $thefield}' | sed "s/\"//g")
    #Grab the value of the field
    myvalue=$(echo ${i} | awk -F , -v var=$x '{print $var}')

    echo "csv.somefile.$myfield $myvalue $starting" | nc -q0 carbonhost 2003

  done
done
