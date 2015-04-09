#!/usr/bin/env python
#################################################
# Insert marks in the matrix file to 
# allow the identification of different
# profiles in the peering matrix
#
# input file 1: matrix file
#
# input file 2: AS \t Profile  (tab as separator)
#
# Example: 38881 1.1
#          48822 1.2
#
#################################################

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
import math
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import numpy as np


if len(sys.argv)==3:
	profileFile=sys.argv[1]
	matrixFile=sys.argv[2]
else:
	print "Usage: " + sys.argv[0] + " <profile_separtor>" + " <matrix_file>"
	sys.exit(0)

#-----------------------------------------------------------------------
#Feeds list with matrix file
e2=open(matrixFile, 'r') # read matrix
matrix=[]
for line in e2:
 matrix.append(line)

#-----------------------------------------------------------------------
#identify the lines of the profile file that should be marked 
e1=open(profileFile, 'r') # read profile

line=e1.readline()
count=len(line.strip().split('\t'))
if count != 2:
  print "Erro. Arquivo fora do formato"
  sys.exit()

lastPattern=str(line.strip().split('\t')[1])
i=0
index=[]
for line in e1:
  newPattern=str(line.strip().split('\t')[1])
  if newPattern != lastPattern:
    lastPattern=newPattern
    index.append(i+1)
  i+=1

#insert marks
index.reverse() # start inserting from the last elements
for i in index:
    matrix.insert(i,"#\n")	
  
#print matrix
for row in matrix:
	for i in row:
		sys.stdout.write(str(i))
	#print 
	
	  
#np.savetxt(destinationFile, NumpM, delimiter=' ', newline="\n", fmt='%d')

