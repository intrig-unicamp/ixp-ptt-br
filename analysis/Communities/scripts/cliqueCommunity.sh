#!/usr/bin/env python
#################################################
# k-clique communities
#	
# Inputs:
#  -  ptt_*, AS Path from looking glass
#  -  k value
#
# The ASPath is a sequence of ASNs
#
# http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5961378
# Results:
#  - number of SAs of the communities
#  - number of communities
#  - max size among communities given a fixed k value
#  - density of a community
#  - average ODF (Out Degree Fraction) of a community
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

e1=open(file, 'r') # read info file

G=nx.Graph()

#-----------------------------------------------------------------------
i=0;ii=[];k=1;j=0;jj=0;t=0;w=[];z=[];zz=[];d=[];mylist=[];mylist1=[] ;
node = [[0 for x in xrange(50)] for x in xrange(330000)]

for line in e1:
    count=len(line.strip().split(' '))
    while i <= count:
        if (i==0):
            node[j][i]=26121
            G.add_node(26121)
        elif((i>0) and (node[j][k-1]!=line.strip().split(' ')[i-1])):
            node[j][k] = int(line.strip().split(' ')[i-1])
            G.add_node(node[j][k])
            G.add_edge(node[j][k-1],node[j][k])
	    k+=1
        i+=1
    t+=1
    i=0
    k=1
    j+=1


#-------------------------------------------------------------------------
#---Graph------------------------------------------------------------------

print "Listing communities: " + str(kCommunities)
c = list(nx.k_clique_communities(G, kCommunities))
sum=0
max=0
for i in c:
	x=list(i)
	###############################################
	#print "Size of the community: " + str(len(x))
	###############################################
	tConnections = nCr(len(x),2)
	#print "Possible connections of the community: " + str(tConnections)

	cConnections=0 #current connections inside the community
	avg_ODF=0
	#H as induced subgraph
	H = A.subgraph(x)
	#itera em cada no da comunidade x
	for j in x:
		#remove loops
		if H.has_edge(j,j):
			H.remove_edge(j,j)	
		if G.has_edge(j,j):
			G.remove_edge(j,j)	
		#print "degree of " + str(j)  + ": " + str(H.degree(j))
		cConnections+=H.degree(j)
		odf_node =  H.degree(j) / float(G.degree(j))	#inner degree / total degree (inside and outside)
		avg_ODF += odf_node
	avg_ODF = avg_ODF/float(len(x))
	cConnections = cConnections/2
	#print "Existing connections: " +  str(cConnections)	
	###############################################
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
#print "number of SAs;	number of communities;	max size of a community"
print str(kCommunities) + ";" + str(sum) + ";" + str(len(c)) + ";" + str(max)
###############################################





#-------------------------------------------------------------------------

	
