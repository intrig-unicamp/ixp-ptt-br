#!/usr/bin/env python
#################################################
# Gera grafico de adjacencias por AS
# ordena pelo numero de adjacencias e aplica log(X)
#################################################

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import glob
import math
import sys

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
	print "files have the pattern ptt_<state>.txt (e.g., data/ptt_sp.txt)"
	sys.exit(0)

print "File to open: " + file
print "Will generate: " + "adjacencyLog_ordDegNum_" + file[9:11] + ".eps"


#zf = zipfile.ZipFile('sampson_data.zip') # zipfile object
e1=open(file, 'r') # read info file
#e1=open('table', 'r') # read info file
#e1=cStringIO.StringIO(zf.read('te.txt')) # read info file

G=nx.DiGraph()
A=nx.Graph()

#-----------------------------------------------------------------------
i=0;ii=[];k=1;j=0;jj=0;t=0;w=[];z=[];zz=[];d=[];mylist=[];
node = [[0 for x in xrange(50)] for x in xrange(330000)]

for line in e1:
    count=len(line.strip().split(' '))
    #print "Count: " + str(count)
    #print line.strip().split(' ')
    while i <= count:
        if (i==0):
            node[j][i]=26121
            G.add_node(26121)
            z.append(26121)
      #tinha_so_else
        elif((i>0) and (node[j][k-1]!=int(line.strip().split(' ')[i-1]))):
	    #print "%d != %d" % (node[j][k-1],int(line.strip().split(' ')[i-1]))
            node[j][k] = int(line.strip().split(' ')[i-1])
            G.add_node(node[j][k])
            z.append(int(node[j][k]))

	    zz.append(node[j][k])
            A.add_edge(node[j][k-1],node[j][k])
            G.add_edge(node[j][k-1],node[j][k])
	    k+=1
	#else:
	    #print "%d == %d" % (node[j][k-1],int(line.strip().split(' ')[i-1]))

        i+=1
    G.add_path([node[j][0],node[j][k-1]])
    t+=1
    i=0
    k=1
    j+=1

#X=subgraph(G, 0)
#X = compose(A,A1)
#-----------------------------------------------------------------------
#---Quantidade de nos------
if (checkQntNos):
    print "Quantidade de nos:"
    print len(A.nodes())-1
#--------------------------
#-----------------------------------------------------------------------------
#b = G.nodes()
#print "Nodes:"
#print b
#-----------------------------------
if (checkDepth):
    #print("depth to node 1")
    ii=sorted(A.nodes())
    iii = [[0 for x in xrange(2)] for x in xrange(len(ii))]
    for c in ii:
        print "Depth from 1 to", c, "is", nx.shortest_path_length(A,source=1,target=c)
#        iii[jj][0]=c
 #       iii[jj][1]=((nx.shortest_path_length(A,source=1,target=c)))
  #      jj+=1
   # print sorted(iii,key=itemgetter(1))
#------------------------------------------------------------------------------
#--Degree of each node---------------------------------------------------------
if (checkDegree):
    d = nx.degree(A)
    print "Degree of each node"
    print sorted(d.values())
#-----------------------------------------------------------------------------
#--Plotting image-------------------------------------------------------------
node_size=[]
if (checkPlot):
    colors=[]
    #for n in A.nodes():
    ii=(A.nodes())
    iii = [[0 for x in xrange(2)] for x in xrange(len(ii))]
    for n in ii:
        if nx.shortest_path_length(A,source=26121,target=n) == 0:
            colors.append('g')
        elif nx.shortest_path_length(A,source=26121,target=n) ==1:
            colors.append('b')
        elif nx.shortest_path_length(A,source=26121,target=n) ==2:
            colors.append('r')
        elif nx.shortest_path_length(A,source=26121,target=n) ==3:
            colors.append('y')
        elif nx.shortest_path_length(A,source=26121,target=n) ==4:
            colors.append('w')
        elif nx.shortest_path_length(A,source=26121,target=n) ==5:
            colors.append('w')

#    pos=nx.graphviz_layout(G,prog="twopi",root=26121)
    pos=nx.graphviz_layout(A,prog='dot',root=26121)
#    pos=nx.spring_layout(X, iterations=100)
    plt.clf()
    plt.figure(figsize=(50,50))
    plt.title('Networkx Graph')

    node_color=[float(A.degree(v)) for v in A]

    nx.draw(A,pos,with_labels=False,arrows=False,alpha=0.3,font_size=10,prog='twopi',node_color=colors,node_size=[len(A.neighbors(c))*500 if len(A.neighbors(c))>100 else len(A.neighbors(c))*10 for c in A.nodes()])
   # nx.draw(A1,poss,with_labels=True,alpha=0.3,font_size=12,node_size=2, node_color='b')
    #nx.draw(A,pos,with_labels=True,alpha=0.3,font_size=12,prog='dot',node_size=200,edge_color='r',node_color=colors)
    plt.axis('off')

    xmax=1.02*max(xx for xx,yy in pos.values())
    ymax=1.02*max(yy for xx,yy in pos.values())
    plt.xlim(0,xmax)
    plt.ylim(0,ymax)
    plt.savefig("sampson1.png", dpi = (200))
    plt.show()
#-------------------------------------------------------------------------
#---Number of Neighbors---------------------------------------------------
if (checkNeighbors):
    print("Length of neighbor #1")
    for a in range(len(A.nodes())):
        if (len(A.neighbors(zz[a]))>0):
#        if (len(A.neighbors(zz[a]))>0 and zz[a]!='1'):
            print len(A.neighbors(zz[a]))
#-------------------------------------------------------------------------
#---Graph------------------------------------------------------------------
if (checkGraph):
    d = nx.degree(A)
#    print d
    for key in sorted(d):
      print "%s: %s" % (key, d[key])
#-------------------------------------------------------------------------
