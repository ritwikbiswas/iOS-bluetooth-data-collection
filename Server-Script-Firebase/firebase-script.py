#!/usr/bin/env python
import os
import os.path
import time
import datetime
from firebase import firebase


firebase = firebase.FirebaseApplication('https://sbid.firebaseio.com', None)

#Checks for file and if it exists, wipes it
if os.path.isfile('SBID_Data.txt'):
    os.remove('SBID_Data.txt')

#Initializes time related variables
iteration = 1
current_time = "";

print_once = True;
f = open('SBID.txt', 'a')
while True:

    #Recieve and store data
    time_stamp = firebase.get('/raw_data/time_stamp', None)
    print time_stamp + '\n'
    if (time_stamp == current_time):
        if (print_once):
            print "\n\n******************Timestamp Unchanged******************\n\n"
            print_once = False
        continue;
    print_once = True    
    current_time = time_stamp

    f.write(str(time_stamp))
    
    iteration += 1
    
f.close()

   
