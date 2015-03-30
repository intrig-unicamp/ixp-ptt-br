#!/usr/bin/env python
############################################################
# Compute average of densities for each community (fixed k)
# (easily adapted to ODFs)
#
# File format: k;densityValue;odfValue
#
############################################################

import zipfile, cStringIO
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import glob
import math
import sys
import operator as op

if len(sys.argv)==2:
	file=sys.argv[1]
else:
	print "Usage: " + sys.argv[0] + " <file>"
	sys.exit(0)

e1=open(file, 'r') # read info file

#-----------------------------------------------------------------------
i=0;avg=0;k=0;k_old=0;

k=e1.readline(1)
if k == "#":
  #TODO: improve this
  print "Please remove comments from file (#)"
  sys.exit(0)
else:
  k_old=k

line = e1.readline()
count=len(line.strip().split(';'))
if count != 3:
  print "Unknown file format. Expected: k;density_value;odf_value"
  print "Exiting..."
  sys.exit(0)

value=float(line.strip().split(';')[1])
avg = float(avg + value)
i=i+1  

for line in e1:
    if int(k_old) != int(line.strip().split(';')[0]):
      #print "k_old = " + str(k_old) + " atual= " + str(line.strip().split(';')[0])
      if i == 0:
        print "Divided by zero"
        sys.exit(0)
      avg =  float(avg/i)
      print str(k_old) + " " + str(avg)
      k_old=int(line.strip().split(';')[0])
      avg=0
      i=0

    value=float(line.strip().split(';')[1])
    avg = float(avg + value)
    i=i+1  
 
avg =  float(avg/i)
print str(k_old) + " " + str(avg)
k_old=int(line.strip().split(';')[0])


#-------------------------------------------------------------------------

	
