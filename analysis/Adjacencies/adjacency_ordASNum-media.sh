#!/usr/bin/env python
#################################################
# Grau medio a cada sequencia de X vertices
# ordena pelo numero do AS (ASN)
#
# Requer entrada no padrao ptt_<state>.txt
# em que state pode ter dois ou 3 caracteres
# e.g., ptt_sp.txt, ptt_mgf.txt
#
# OBS: Alocacao estatica de 1738925 listas com
#      50 elementos (PTT_RS requer este tamanho)
#################################################

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import glob
import math
import sys
import numpy as np
import scipy as sp
import scipy.stats

def confidence_interval(data, confidence=0.95):
    a = 1.0*np.array(data)
    n = len(a)
    m, se = np.mean(a), scipy.stats.sem(a)
    h = se * sp.stats.t._ppf((1+confidence)/2., n-1)
    return h

checkQntNos=False
checkDegree=False
checkNeighbors=False
checkGraph=True
checkPlot=False
checkDepth=False

if len(sys.argv)==2:
	file=sys.argv[1]
else:
	print "Usage: " + sys.argv[0] + " data/<file>"
	print "files have the pattern ptt_<state>.txt (e.g., data/ptt_sp.txt or data/ptt_sjc.txt)"
	sys.exit(0)

print "File to open: " + file

if file[11] == '.':
	destinationFile="adjacency_ordASNUM-media_" + file[9:11] + ".eps"
	print "Will generate: " + destinationFile
else:
	destinationFile="adjacency_ordASNUM-media_" + file[9:12] + ".eps"
	print "Will generate: " + destinationFile

#zf = zipfile.ZipFile('sampson_data.zip') # zipfile object
e1=open(file, 'r') # read info file
#e1=open('table', 'r') # read info file
#e1=cStringIO.StringIO(zf.read('te.txt')) # read info file

G=nx.DiGraph()
A=nx.Graph()

#-----------------------------------------------------------------------
i=0;ii=[];k=1;j=0;jj=0;t=0;w=[];z=[];zz=[];d=[];mylist=[];mylist1=[] ;
myCount=0;
node = [[0 for x in xrange(50)] for x in xrange(1738925)]

for line in e1:
    count=len(line.strip().split(' '))
    while i <= count:
        if (i==0):
            node[j][i]=26121
            G.add_node(26121)
            z.append(26121)
      #tinha_so_else
        elif((i>0) and (node[j][k-1]!=int(line.strip().split(' ')[i-1]))):
            node[j][k] = int(line.strip().split(' ')[i-1])
            G.add_node(node[j][k])
            z.append(int(node[j][k]))

	    zz.append(node[j][k])
            A.add_edge(node[j][k-1],node[j][k])
            G.add_edge(node[j][k-1],node[j][k])
	    k+=1
        i+=1
    G.add_path([node[j][0],node[j][k-1]])
    t+=1
    i=0
    k=1
    j+=1


if (checkGraph):
    d = nx.degree(A)
    plt.figure(1)
    mylist=sorted(d.items(),key=itemgetter(0))
    
    #print mylist
    xParam=6
    print "Len of mylist: ", len(mylist)
    numberOfASes = len(mylist)/xParam

    result = [int(i[1]) for i in mylist]

    print "Num ASes: ", numberOfASes
    print result
    cont=0
    x=[];
    x.append(0)
    y=[];
    yerr=[];
    yerrMax=0
    while (cont < xParam):
        init=numberOfASes*cont
	end=numberOfASes*(cont+1)
	print "range(" + str(init) + "," + str(end) + ")"
	sum=0
        errData=[];
        for i in range(init,end):
		sum += result[i]
		errData.append(result[i])
	avg = sum/(end-init) 
	print "Average= ", avg        
	cont = cont + 1
	x.append(cont*numberOfASes)
	y.append(avg)
        yerr.append(confidence_interval(errData))
    y.append(0)
    yerr.append(0)
    print x
    print y
###
    plt.bar(x, y, width=(end-init), yerr=yerr, linewidth=1.3, color='white', ecolor='#000000', edgecolor='blue', hatch="xx")
#    plt.bar(x, y, width=(end-init), yerr=yerr, linewidth=1.3, color='white', ecolor='#000000', edgecolor='red', hatch="x")
#    plt.bar(x, y, width=(end-init), yerr=yerr, linewidth=1.3, color='blue', ecolor='#000000')
    plt.xticks(x)
    plt.xlabel("Vertices (ordenados por #ASN)", fontsize=22)
    plt.ylabel("Grau medio", fontsize=22)
    plt.tick_params(axis='both', which='major', labelsize=16)
    plt.ylim([0,max(y)+1+max(yerr)])
    plt.margins(0.05)
    plt.savefig(destinationFile)

    

#-------------------------------------------------------------------------
