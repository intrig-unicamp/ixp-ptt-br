#!/usr/bin/env python

import networkx as nx
import matplotlib.pyplot as plt
import math
from networkx import *
from operator import itemgetter, attrgetter, methodcaller

checkPlot=True

filename='ptt_graph_members'

e1=open('ptt_graph_members_dataset.txt', 'r') # read info file

G=nx.DiGraph()
A=nx.Graph()

#-----------------------------------------------------------------------
i=0;ii=[];k=1;j=0;jj=0;t=0;w=[];z=[];zz=[];d=[];mylist=[]
node = [[0 for x in xrange(20)] for x in xrange(100000)]

for line in e1:
    count=len(line.strip().split(' '))
    while i <= count:
        if (i==0):
            G.add_node(node[j][i])
        elif((i>0) and (node[j][k-1]!=line.strip().split(' ')[i-1])):
            node[j][k] = str(line.strip().split(' ')[i-1])
            A.add_edge(node[j][k-1],node[j][k])
	    k+=1
        i+=1
    t+=1
    i=0
    k=1
    j+=1

#--Plotting image-------------------------------------------------------------
if (checkPlot):
    pos=nx.spring_layout(A)
    plt.clf()
    plt.figure(figsize=(100,100))
    plt.title('PTT Members')

    ptt_labels={"AME","BEL","MG","DF","CPV","CAS","CGB","CXJ","PR","SC","CE","GYN","LAJ","LDA","MAO","MGF","NAT","RS","PE","RJ","BA","SCA","SJC","SJP","SP","VIX"}
    labels = {}
    for node in G.nodes():
        if node in ptt_labels:
            #set the node name as the key and the label as its value
            labels[node] = node

    nx.draw(A,pos,with_labels=False,linewidths=0.6,width=0.6,arrows=False,alpha=0.2,font_size=12,node_color='y',node_size=[len(A.neighbors(c))*5 if len(A.neighbors(c))>30 else len(A.neighbors(c))*3 for c in A.nodes()])
    nx.draw_networkx_labels(G,pos,labels)
    plt.axis('off')

    plt.savefig(str(filename)+'.eps', format='eps', rasterized=True, dpi = (100))
    plt.show()
#-------------------------------------------------------------------------
