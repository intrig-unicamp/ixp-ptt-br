#!/usr/bin/env python
####################################################################
# Given a matrix, create new indexes as sums of the columns right before
# in a range according to each profile
# Goal is to provide the number of connections for each profile
# 
# Indexes are created for each row
#
# For example: 1 1 0 0 1 1 0 0 1 creates the new indexes as follows (see quotes) 
#              1 1 "2" 0 0 1 "1" 1 0 0 1 "2"
# Positions are chosen according to the number of members in a profile
# so we know the amount of connections for each profile
# input file: matrix passed as first argument
# ouput: stdout
####################################################################

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
import math
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import numpy as np

def scale(s,n):
     #print "return 6*" + str(s) + "/" + str(n) + "=" + str(6*s/n) 
     #return (str(6*s/n))
     return (str(s/n)) 

if len(sys.argv) == 2:
	file=sys.argv[1]
else:
	print "Usage: " + sys.argv[0] + " <file>"
	sys.exit(0)

e1=open(file, 'r') # read info file

linecount=0
profile_delimiters=[]
#obtain lines that represents the "#" (hashes) 
#shound discount numbers of hashes incrementally
i=0
for line in e1:
	if str(line.strip().split(' ')[0]) == '#':
		profile_delimiters.append(linecount-i)
		i+=1
	linecount+=1

profile_delimiters.append(linecount-i) #last line
e1.close()

print "Profile delimiters"
for i in profile_delimiters:
	print str(i) + " "

if len(profile_delimiters) == 0:
	print "ERROR 101"
	sys.exit(0)

e1=open(file, 'r') # read info file

sum_list=[]
#initialize list of sums with zeros
#for index in range(len(profile_delimiters)): 
#	sum_list.insert(index,0)

#sum for each group of profile in the profile_delimiters[]
#end=int(profile_delimiters[0])
for line in e1:
	init=0
	#print "####################"
	i=0
	list=line.strip().split(' ')
	#print "Total size of line: " + str(len(list))	
	if str(list[0]) != "#": 
		#:----#-----#--------#---------
		for k in range(len(profile_delimiters)):
		  	#print "= " + str(k) 
			end=int(profile_delimiters[i])
			#print "sum_list"
			#for p in sum_list:
			#	sys.stdout.write(str(p) + " ")
			#print "\nend sum_list"		
			sum=0
			#print "--------------------------"
			#print "range(" +  str(init) + "," + str(end) + ")"
			for x in range(init,end):	
				sum+=int(list[x])
			#print "sum_list.pop(" + str(i) + ")"
			#sum+=int(sum_list.pop(i))
			#print "insert(" + str(i) + "," + str(sum) + ")"	
			sum_list.append(int(sum))
			i+=1
			init=int(end)
		sum_list.append("\n")	

e1.close()
#print "Somas"
sys.stdout.write("   ")
for p in sum_list:
	sys.stdout.write(str(p) + "   ")
print

#sums columns related to profiles
count=0
countN=0
col=0
#sum=int(sum_list[col])	
numProfile=int(len(profile_delimiters)) #number of profiles
numProfile+=1 #due to \n
for col in range(0,numProfile-1):
	print
	print "numProfile=" + str(col)
	sum=int(sum_list[col])	
	#print "##########"
	count=0
	countN=0
	for i in range(numProfile-1, len(sum_list), numProfile):
		#print "============="
		#print "i=" + str(i)
		if (sum_list[i] == "\n"):
			countN+=1
			if countN == profile_delimiters[count]:
			  #print "countN=" + str(countN)
			  #Compute the medium
			  if count==0:
			    n=profile_delimiters[count]
			  else:
			    n=profile_delimiters[count]-profile_delimiters[count-1]
			  print str(sum/float(n))
			  if i != len(sum_list)-1:
			    sum=int(sum_list[i+1+col])
			  count+=1
		 	else:
			  #print "sum+=" + str(sum_list[i+1])
			  #print "index=" + str(i+1+col)
			  sum+=int(sum_list[i+1+col])	

	
