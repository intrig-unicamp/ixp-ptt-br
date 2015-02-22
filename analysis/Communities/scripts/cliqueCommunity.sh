#!/usr/bin/env python
#################################################
# Obtem os seguintes parametros relacionados com
# k-clique communities
#	
# http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5961378
# numero de ASes de uma comunidade (com repeticao)
# numero de comunidades
# tamanho max entre comunidades com um mesmo k
# densidade de uma comunidade
# average ODF (Out Degree Fraction)
#################################################

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import glob
import math
import sys
#import math
import operator as op

def nCr(n, r):
    r = min(r, n-r)
    if r == 0: return 1
    numer = reduce(op.mul, xrange(n, n-r, -1))
    denom = reduce(op.mul, xrange(1, r+1))
    return numer//denom

if len(sys.argv)==3:
	file=sys.argv[1]
	kCommunities=int(sys.argv[2])
else:
	print "Usage: " + sys.argv[0] + " data/<file>" + " <k>"
	print "files have the pattern ptt_<state>.txt (e.g., data/ptt_sp.txt)"
	sys.exit(0)

#print "File to open: " + file
#print "Will generate: " + "adjacencyLog_ordASNUM_" + file[9:11] + ".eps"
#print "Finding clique communities for k=" + str(kCommunities)

#zf = zipfile.ZipFile('sampson_data.zip') # zipfile object
e1=open(file, 'r') # read info file
#e1=open('table', 'r') # read info file
#e1=cStringIO.StringIO(zf.read('te.txt')) # read info file

G=nx.DiGraph()
A=nx.Graph()

#-----------------------------------------------------------------------
i=0;ii=[];k=1;j=0;jj=0;t=0;w=[];z=[];zz=[];d=[];mylist=[];mylist1=[] ;
node = [[0 for x in xrange(50)] for x in xrange(330000)]

for line in e1:
    count=len(line.strip().split(' '))
    while i <= count:
        if (i==0):
            node[j][i]=26121
            G.add_node(26121)
            z.append(26121)
      #tinha_so_else
        elif((i>0) and (node[j][k-1]!=line.strip().split(' ')[i-1])):
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


#-------------------------------------------------------------------------
#---Graph------------------------------------------------------------------

#for count in range(2,9):
count=kCommunities
#print "Listing communities: " + str(count)
#print "--"
c = list(nx.k_clique_communities(A, count))
sum=0
max=0
for i in c:
	x=list(i)
	#x.sort
	###############################################
	#print "Tamanho da comunidade: " + str(len(x))
	###############################################
	tConnections = nCr(len(x),2)
	#print "Total de conexoes possiveis da comunidade: " + str(tConnections)

	cConnections=0 #current connections inside the community
	avg_ODF=0
	#H como subgrafo induzido pelos nos da comunidade x
	H = A.subgraph(x)
	#itera em cada no da comunidade x
	for j in x:
		#remove laco 
		if H.has_edge(j,j):
			H.remove_edge(j,j)	
		if G.has_edge(j,j):
			G.remove_edge(j,j)	
		#print "grau de " + str(j)  + ": " + str(H.degree(j))
		cConnections+=H.degree(j)
		odf_node =  H.degree(j) / float(G.degree(j))	#razao entre grau dentro da comunidade e grau total (dentro e fora)
		avg_ODF += odf_node
	avg_ODF = avg_ODF/float(len(x))
	cConnections = cConnections/2
	#print "Conexoes atuais da comunidade: " +  str(cConnections)	
	###############################################
	#print("Densidade da comunidade: %.2f" % cConnections/float(tConnections))
	#print "Media do ODF da comunidade: " + str(avg_ODF)
	density=cConnections/float(tConnections)
	print("%d;%.2f;%.2f" % (kCommunities, density,avg_ODF))
	###############################################
	if (len(x) > max):
		max=len(x)
	sum+=len(x)
	plt.show()
	H.clear()
	#print "--"
###############################################
#print "numero de ASes (com repeticao);	numero de comunidades;	tamanho max de uma comunidade"
#print str(kCommunities) + ";" + str(sum) + ";" + str(len(c)) + ";" + str(max)
###############################################





#-------------------------------------------------------------------------

	
