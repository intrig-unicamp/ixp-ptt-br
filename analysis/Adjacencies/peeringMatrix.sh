#!/usr/bin/env python
#########################################
# Generates the peering matrix, i.e.,
# matriz that represents pairwise 
# connections between IXP members
#
# input file: show ip bgp paths
# i.e., AS Paths
#
# Example: count  AS1 AS2  AS3  ... ASN
#            2   1881 3456 8176
#########################################

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
import math
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import numpy

def intersect(a, b):
     return list(set(a) & set(b))

if len(sys.argv)==2:
	file=sys.argv[1]
else:
	print "Usage: " + sys.argv[0] + " data/<file>"
	print "files have the pattern ptt_<state>.txt (e.g., data/ptt_sp.txt)"
	sys.exit(0)

if file[11] == '.':
	destinationFile="peeringMatrix_" + file[9:11] + ".eps"
	print "Will generate: " + destinationFile
else:
	destinationFile="peeringMatrix_" + file[9:12] + ".eps"
	print "Will generate: " + destinationFile


#print "File to open: " + file


e1=open(file, 'r') # read info file

#-----------------------------------------------------------------------
G=nx.Graph()
i=0;k=1;j=0;nPrepends=0;
allPrepend=[]
membros=[]
node = [[0 for x in xrange(50)] for x in xrange(10)]

for line in e1:
    count=len(line.strip().split(' '))
    if count<2:
	print "Erro. Arquivo fora do formato"
	sys.exit()
    #desconsidera linha com apenas um AS, mas cadastra membro
    if count==2:
	i=100
        newMember=int(line.strip().split(' ')[1])
	#print str(newMember)
        #insere membro se este nao esta na lista
        if membros.count(newMember) == 0:
            membros.append(newMember)
	    G.add_edge(newMember,newMember)

    #count vai ate terceira coluna (1a eh contagem; 2a e 3a sao SAs)
    #observe que SA membro esta na 2a coluna e 3a indica o prepend
    while i <= count:
        #adiciona membro
	if i==3:
          #print "Insere membro: " + str(node[j][k-1])
          #insere membro se este nao esta na lista
          if membros.count(int(node[j][k-1])) == 0:
            membros.append(int(node[j][k-1]))
	    G.add_edge(int(node[j][k-1]),int(node[j][k-1]))

	#print "j=" + str(j) + " k=" + str(k) + " i=" + str(i)
	#if (i!=0):
	    #print str(node[j][k-1]) + "!=" + line.strip().split(' ')[i-1]
        if (i==0):
            node[j][i]=26121
        elif((i>0) and (node[j][k-1]!=int(line.strip().split(' ')[i-1]))):
            node[j][k] = int(line.strip().split(' ')[i-1])
	    if membros.count(int(node[j][k-1])) != 0:
	        if membros.count(int(node[j][k])) != 0:  
	            G.add_node(node[j][k])
		    G.add_edge(node[j][k-1],node[j][k])
	    k+=1
        i+=1
    #print "---"
    i=0
    k=1
    #nao precisa somar sempre (economiza espaco no vetor)
    if j==3:
       j=0
    else:
       j+=1

for line in nx.generate_edgelist(G, data=False):
    print(line)

print "Num membros: " + str(len(membros))
A = nx.adjacency_matrix(G)
print(A.todense())

NumpM = to_numpy_matrix(G)
plt.imshow(NumpM,  cmap='Greys', interpolation='nearest')
#plt.show()
plt.savefig(destinationFile)
