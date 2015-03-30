#!/usr/bin/env python

import networkx as nx
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np 
import glob
from networkx import *
from operator import itemgetter, attrgetter, methodcaller


hatch="xx"
color="blue"
ecolor="blue"
edgecolor="blue"

f2 = open('graphic_dataset.txt', 'r')
newlines = f2.readlines()
f2.close()

# initialize some variable to be lists:
x1 = []
y1 = []

# scan the rows of the file stored in lines, and put the values into some variables:
for newline in newlines:
    p = newline.split()
    x1.append(float(p[0]))
    y1.append(float(p[1]))
  
xv = np.array(x1)
yv = np.array(y1)


plt.bar(xv, yv, linewidth=1.3, color=color, ecolor=ecolor, edgecolor=edgecolor, hatch=hatch, align='center')
plt.xticks(xv)
plt.title("Number of PTTs x Number of ASes")
plt.xlabel("Number of PTTs", fontsize=18)
plt.ylabel("Number of ASes", fontsize=18)
plt.tick_params(axis='both', which='major', labelsize=14)
plt.ylim([0,1000])
plt.margins(0.02, 0.0)
print "Processing PTT ..."
plt.savefig("pttxases.eps")
plt.clf()
