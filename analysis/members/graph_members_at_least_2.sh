#!/usr/bin/env python

import networkx as nx
import matplotlib.pyplot as plt
import math
import os
import glob
from networkx import *
from operator import itemgetter, attrgetter, methodcaller

#Read this file
file_name="report_graph_members.txt"
#At current path
myPath="."
#Save the file
files=glob.glob1(myPath,file_name)
#output file name
outputfile="members_sorted.txt"
#remove the output file if it exists
os.system('rm '+ outputfile)

o=0;
exists=False;
node = [[0 for x in xrange(2)] for x in xrange(1000)]

e1=open(file_name, 'r')
print "Processing File..."+file_name

i=0;j=0;

#Read Path files
for line in e1:
    j+=1
    #Read the columns
    while i <= 1:
        #If first column
        if (i==0):
            #Save the ASN ID
            node[o][0]=str(line.strip().split(' ')[0])
        #If second column
        elif(i==1):
            node[o][1]=str(line.strip().split(' ')[1])
            #os.system('echo '+str(node[o][0])+" "+str(node[o][1])+'  >> '+file_name)
            o+=1
        #Go to next column
        i+=1
    #Go to column 0
    i=0
#---------------------------------------------------------------------
member=""
members=["0"]
ptt=""
for line in range(0,j):
    member=str(node[line][1])

    for line_ in range(line+1,j):
        if(str(node[line_][1])==member and member not in members):
            members.append(member)

#remove member 0
members.pop(0)
#----------------------------------------------------------------------
membersptt=[]
membersorted=[]
for line in range(0,len(members)):
    for line_ in range(0,j):
        if(members[line]==node[line_][1]):
           ptt=ptt+" "+node[line_][0]
    membersptt.append(str(members[line])+":"+str(ptt))
    ptt=""

membersorted = sorted(membersptt)

#Save the list of sorted members
for line in range(0,len(membersorted)):
    os.system('echo ASN:'+membersorted[line]+'  >> '+"members_sorted.txt")
os.system('echo TOTAL ASNs:'+str(j)+' >> '+outputfile)
