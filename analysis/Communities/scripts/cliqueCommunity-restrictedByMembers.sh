#!/usr/bin/env python
####################################################
# Restricts the general community results to
# the scope of IXP members
#
# Inputs: 
# - members.txt containing members of each IXP
# - data/ptt_* containing each IXP AS PAth
#
# The AS Path file is a sequence of #ASNs without
#the prepend count that appears in the 1st column
####################################################

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

if len(sys.argv)==2:
	kCommunities=int(sys.argv[1])
else:
	print "Usage: " + sys.argv[0] + " <k>"
	sys.exit(0)

#Path of the file
myPath="data"
#Amount of Ptt_Path files
pttPathCounter = len(glob.glob1(myPath,"ptt_*"))
#Save in Array the ptt_ files
files=glob.glob1(myPath,"ptt_*")

#file with members
e2=open("members.txt", 'r')

G=nx.Graph()

#-----------------------------------------------------------------------
#i=0;ii=[];k=1;j=0;jj=0;t=0;w=[];z=[];zz=[];d=[];mylist=[];mylist1=[];nPrepends=0;
G=nx.Graph()
allPrepend=[]
membros=[]

if kCommunities<3:
	print "Note that value of k is low. Communities will not be computed"

######### Read the file with members and include them in an array and add the node in the graph
node = [[0 for x in xrange(50)] for x in xrange(10)]

for line in e2:
    count=len(line.strip().split(' '))
    if count==1:
	newMember=int(line.strip().split(' ')[0])
	if membros.count(newMember) == 0:
            membros.append(newMember)
	    G.add_node(newMember)
	    #print " New member: " + str(newMember)	

    else:
	print "Error. Invalid file format"
	sys.exit()

#print "\n Num membros: " + str(len(membros))
#for line in nx.generate_edgelist(G, data=False):
#    print(line)

#-------------------------------------------------------------------------
#Create connections of members
node = [[0 for x in xrange(50)] for x in xrange(11)]

for file in range(0,pttPathCounter):
	name = files[file]
	#Identify a file by ID (Ex: ptt_sp, ptt_mg...)
	if name[6] == ".":	
	  filename=name[4:6]
        else:
	  filename=name[4:7]
	#Save contents of files
	e1=open('data/ptt_'+filename+'.txt', 'r')
	#Processing current file
	print "Processing PTT "+filename+"..."

	i=0; k=1; j=0;
	for line in e1:
	    count=len(line.strip().split(' '))
	    node[0][0]=int(line.strip().split(' ')[0])
	    while i <= count:
		if((i>1) and (node[j][k-1]!=int(line.strip().split(' ')[i-1]))):
		    node[j][k] = int(line.strip().split(' ')[i-1])
		    #add edge only if they are members
		    if membros.count(node[j][k-1]) != 0:
		      if membros.count(node[j][k]) != 0:
		        G.add_edge(node[j][k-1],node[j][k])
		    k+=1
		i+=1
	    #G.add_path([node[j][0],node[j][k-1]])
	    i=0
	    k=1
	    j+=1
	    if j>10:
		j=0;

#print "\n Printing edge list"
#for line in nx.generate_edgelist(G, data=False):
#    print(line)



#-------------------------------------------------------------------------
#Community processing

if kCommunities<3:
	print "Value of k less than 3. Aborting..."
	sys.exit()

print "Processing k=4,5,...,12"
for count in range(4,13):
	print "Listing communities k=" + str(count)
	#print "--"
	c = list(nx.k_clique_communities(G, count))
	sum=0
	max=0
	for i in c:
		x=list(i)
		tConnections = nCr(len(x),2)
		cConnections=0 #current connections inside the community
		avg_ODF=0
		#H is the subgraph generated by community nodes
		H = G.subgraph(x)
		for j in x: 
			if H.has_edge(j,j):
				H.remove_edge(j,j)	
			if G.has_edge(j,j):
				G.remove_edge(j,j)	
			cConnections+=H.degree(j)
			odf_node =  H.degree(j) / float(G.degree(j))	#inner degree / total degree 
			avg_ODF += odf_node
		avg_ODF = avg_ODF/float(len(x))
		cConnections = cConnections/2
		density=cConnections/float(tConnections)
		print "k; community density; average ODF of the community"
		print("%d;%.2f;%.2f" % (count, density,avg_ODF))
		###############################################
		if (len(x) > max):
			max=len(x)
		sum+=len(x)
		plt.show()
		H.clear()
		#print "--"
	###############################################
	print "k;number of SAs ; number of communities;	max size of a community"
	print str(count) + ";" + str(sum) + ";" + str(len(c)) + ";" + str(max)
	###############################################





#-------------------------------------------------------------------------

	
