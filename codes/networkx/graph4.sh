#!/usr/bin/env python

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
import math
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
#import glob

checkQntNos=False
checkDegree=False
checkNeighbors=False
checkGraph=False
checkPlot=True
checkDepth=False

filename='Ptt_Path_RS'
Degree = 5

#zf = zipfile.ZipFile('sampson_data.zip') # zipfile object
#e1=open('sem1', 'r') # read info file
e1=open('PTT_PATH/'+str(filename)+'.txt', 'r') # read info file
#e1=open('PTT_PATH/Ptt_Path_SP.txt', 'r') # read info file
#e1=open('table', 'r') # read info file
#e1=cStringIO.StringIO(zf.read('te.txt')) # read info file

G=nx.DiGraph()
A=nx.Graph()

#-----------------------------------------------------------------------
i=0;ii=[];k=1;j=0;jj=0;t=0;w=[];z=[];zz=[];d=[];mylist=[]
node = [[0 for x in xrange(150)] for x in xrange(23830000)]

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
#X=subgraph(G, 0)
#X = compose(A,A1)
#-----------------------------------------------------------------------
#---Quantidade de nos------
if (checkQntNos):
    print "Quantidade de nos:"
    print len(A.nodes())-1
    print sorted(A.nodes())
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
#node_size=[]
if (checkPlot):
#    colors=[]
    #for n in A.nodes():
 #   ii=(A.nodes())
  #  iii = [[0 for x in xrange(2)] for x in xrange(len(ii))]
  #  for n in ii:
   #     if nx.shortest_path_length(A,source=26121,target=n) == 0:
   #         colors.append('g')
   #     elif nx.shortest_path_length(A,source=26121,target=n) ==1:
   #         colors.append('b')
   #     elif nx.shortest_path_length(A,source=26121,target=n) ==2:
   #         colors.append('r')
   #     elif nx.shortest_path_length(A,source=26121,target=n) ==3:
   #         colors.append('y')
   #     elif nx.shortest_path_length(A,source=26121,target=n) ==4:
   #         colors.append('w')
   #     elif nx.shortest_path_length(A,source=26121,target=n) ==5:
   #         colors.append('w')
    remove = [n for n, degree in A.degree().items() if degree < Degree]
#    pos=nx.spring_layout(A, iterations=10000000)
   # print remove
    A.remove_nodes_from(remove)
    pos=nx.spring_layout(A)
    plt.clf()
    plt.figure(figsize=(40,40))
    plt.title('Networkx Graph')

#    node_color=[float(A.degree(v)) for v in A]

    nx.draw(A,pos,with_labels=False,linewidths=0.1,width=0.1,arrows=False,alpha=0.3,font_size=10,node_color='b',node_size=[len(A.neighbors(c))*10 if len(A.neighbors(c))>100 else len(A.neighbors(c))*2 for c in A.nodes()])
#    nx.draw(A,pos,with_labels=False,arrows=False,alpha=0.3,font_size=10,prog='twopi',node_color=colors,node_size=[len(A.neighbors(c))*500 if len(A.neighbors(c))>100 else len(A.neighbors(c))*10 for c in A.nodes()])
   # nx.draw(A1,poss,with_labels=True,alpha=0.3,font_size=12,node_size=2, node_color='b')
    #nx.draw(A,pos,with_labels=True,alpha=0.3,font_size=12,prog='dot',node_size=200,edge_color='r',node_color=colors)
    plt.axis('off')

 #   xmax=1.02*max(xx for xx,yy in pos.values())
 #   ymax=1.02*max(yy for xx,yy in pos.values())
 #   plt.xlim(0,xmax)
 #   plt.ylim(0,ymax)
    plt.savefig(str(filename)+'.eps', format='eps', rasterized=True, dpi = (200))
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
    plt.figure(1)


    #ii=sorted(A.nodes())
#    iii = [[0 for x in xrange(2)] for x in xrange(len(d))]
 #   for c in d:
#       iii[jj][0]=d.values()
 #      iii[jj][1]=A.nodes(c)
  #      jj+=1
  #  print sorted(iii,key=itemgetter(1))
    mylist1=[]
    mylist1=sorted(d.items(),key=itemgetter(0))

    for list in mylist1:
#    for list in d.values():
        mylist.append(math.log10(float(list[1])))

        #print list[1]
#    plt.plot(mylist)
#    plt.plot(sorted(mylist))
    plt.plot(mylist)

#    x.append(float(item))
    plt.xlabel("Sequence of ASes")
    plt.ylabel("Number of Adjacencies")
    plt.title("Graphic")
    plt.savefig("graphic.eps")
    plt.show()
#-------------------------------------------------------------------------
