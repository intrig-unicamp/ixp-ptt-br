#!/usr/bin/env python
####################################################################
# Given a matrix, create the last index of each row 
# as a sum of the columns
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

def scale(s,n):
     #print "return 6*" + str(s) + "/" + str(n) + "=" + str(6*s/n) 
     return (str(6*s/n))

if len(sys.argv) == 2:
	file=sys.argv[1]
else:
	print "Usage: " + sys.argv[0] + " <file>"
	sys.exit(0)

e1=open(file, 'r') # read info file
i=0

matrix=[]
values=[]
sum=0
for line in e1:
	matrix.append(line)
	count=len(line.strip().split(' '))
	i=0
	sum=0
	if str(line.strip().split(' ')[i]) == '#':
	  values.append(' ')
	else:
	  while i<count:
	    sum=sum+int(line.strip().split(' ')[i])
	    i+=1	
	  values.append(scale(sum,count))

	  
new_matrix=[]
list=[]
i=0
for row in matrix:
	list=row.strip().split(' ')
	list.append(values[i])
	new_matrix.append(list)
	i+=1

for row in new_matrix:
	for i in row:
		sys.stdout.write(str(i) + " ")
	print 











