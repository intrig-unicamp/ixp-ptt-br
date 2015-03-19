#!/usr/bin/env python

import networkx as nx
import matplotlib.pyplot as plt
import math
import os
import glob
from networkx import *
from operator import itemgetter, attrgetter, methodcaller

#Output File
output_file_name="report_graph_members.txt"
#Remove the output file if it exists
os.system('rm '+ output_file_name)
#Path of the file
myPath="../PTT_PATH"
#Amount of Ptt_Path files
pttPathCounter = len(glob.glob1(myPath,"Ptt_Path*"))
#Save in Array the Ptt_Path files
files=glob.glob1(myPath,"Ptt_Path*")

o=0;
exists=False;
#Starts Array
node = [[0 for x in xrange(3)] for x in xrange(2800000)]

#Read Ptt_Path files
for file in range(0,pttPathCounter):
    name = files[file]
    #Identify a file by ID (Ex: Ptt_Path_SP, Ptt_Path_MG...)
    filename=''.join(e for e in name[9:12] if e.isalnum())
    #Save contents of files
    e1=open('../PTT_PATH/Ptt_Path_'+filename+'.txt', 'r')
    #Processing current file
    print "Processing PTT "+filename+"..."

    i=0;j=0;

    #Read Ptt_Path files
    for line in e1:
        #Read columns
        while i <= 1:
	    #If first line
            if (i==0):
                #Save the ASN ID
                node[o][0]=filename
            #If second line
            elif(i==1):
                for k in range(0,o+1):
    	            if (str(line.strip().split(' ')[0]) in str(node[k][1]) and filename in str(node[k][0])):
                        exists=True

                if (exists==False):
                     node[o][1] = str(line.strip().split(' ')[0])
                     os.system('echo '+str(node[o][0])+" "+str(node[o][1])+'  >> '+output_file_name)
                     o+=1

            exists=False
            #Go to a new line
            i+=1

        #Go to column 0
        i=0


