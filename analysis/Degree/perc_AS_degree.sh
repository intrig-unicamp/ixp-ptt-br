#!/usr/bin/env python

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import glob

checkGraph=True

#Caminho dos arquivos de Path a serem lidos
myPath="../PTT_PATH"
#Contador da quantidade de arquivos de Path
pttPathCounter = len(glob.glob1(myPath,"Ptt_Path*"))
#Armazena em Array o nome dos arquivos de Path
files=glob.glob1(myPath,"Ptt_Path*")

#Laco para leitura dos arquivos de Path
for file in range(0,1): #pttPathCounter):
    #Variavel de armazenamento de cada arquivo de Path
    name = files[file]
    #Variavel de armazenamento dos identificadores dos Ptts (Ex: Ptt_Path_SP - Recupera apenas o id$
    filename=''.join(e for e in name[9:12] if e.isalnum())
    #Variavel de armazenamento do conteudo dos arquivos de Path
    filename="PE"
    e1=open('../PTT_PATH/Ptt_Path_'+filename+'.txt', 'r')
    #Leitura atual de arquivo
    print "Processing PTT "+filename+"..."

    f=open('../graphics_AS_degree/degree_plot_'+filename+'.dat', 'w')

    A=nx.Graph()

    i=0;ii=[];k=1;j=0;d=[]
    node = [[0 for x in xrange(500)] for x in xrange(2330000)]

    for line in e1:
        count=len(line.strip().split(' '))
        while i <= count:
            if (i==0):
                node[j][i]=26121
            elif((i>0) and (node[j][k-1]!=int(line.strip().split(' ')[i-1]))):
                node[j][k] = int(line.strip().split(' ')[i-1])
                A.add_edge(node[j][k-1],node[j][k])
	        k+=1
            i+=1
        i=0
        k=1
        j+=1

#-------------------------------------------------------------------------
#---Graph------------------------------------------------------------------
    if (checkGraph):
        d = nx.degree(A)
        y=[]
        total=0;
        u=0
        x=[]

        for i in range(len(A.nodes())):
	    for a in d:
	        if (A.degree(a)==i):
		    u+=1
	    if(u!=0 and i<11):
	        y.insert(i,u)
	        x.append(i)
	    total=total+u
            u=0
        for i in range(len(y)):
            if(i<11):
	        y[i]=float(format((float(y[i]*100)/total), '.2f'))
	    data = "{} {}\n".format(x[i],y[i])
    	    f.write(data)
        f.close()
#-------------------------------------------------------------------------
