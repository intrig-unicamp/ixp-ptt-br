#!/usr/bin/env python
####################################################################
# Remove zero lines and zero columns from matrix
# 
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

if len(sys.argv) == 2:
	file=sys.argv[1]
else:
	print "Usage: " + sys.argv[0] + " <file>"
	sys.exit(0)

e1=open(file, 'r') # read info file
i=0

# index list contains the indices of the columns to be removed
# matrix list contains the matrix after removing rows
index=[]
matrix=[]
linenum=0
for line in e1:
	count=len(line.strip().split(' '))
	remove=1
	i=0
	while i<count:
	  #print str(line.strip().split(' ')[i])
	  if str(line.strip().split(' ')[i]) == '#':
	    linenum-=1
	    remove=0
	    break 
	  if int(line.strip().split(' ')[i]) == 1:
	    remove=0
	    break
	  i+=1
	if remove == 0:
	  #sys.stdout.write(str(line))	    
	  matrix.append(str(line))
	else:
	  index.append(linenum)
	#  print "removed " +  str(line)
	linenum+=1

#remove collumns
new_matrix=[]
list=[]
for row in matrix:
	list=row.strip().split(' ')
	#print "Len: " + str(len(list))
	i=0
	#note that we need to start removing last columns, otherwise indices change
	if str(row.strip().split(' ')[0]) != '#':
	  while i<len(index): 
	    #print str(index[len(index)-i-1])
	    list.pop(index[len(index)-i-1])
	    i+=1
	new_matrix.append(list)


for row in new_matrix:
	for i in row:
		sys.stdout.write(str(i) + " ")
	print 











