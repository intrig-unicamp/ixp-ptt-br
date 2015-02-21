#!/usr/bin/env python

import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
import math
import os
import glob
from networkx import *
from operator import itemgetter, attrgetter, methodcaller

#Nome do arquivo de saida a ser gerado
file_name="report_graph_members.txt"
#Remove o arquivo de saida se ja existir
os.system('rm '+ file_name)
#Caminho dos arquivos de Path a serem lidos
myPath="../PTT_PATH"
#Contador da quantidade de arquivos de Path
pttPathCounter = len(glob.glob1(myPath,"Ptt_Path*"))
#Armazena em Array o nome dos arquivos de Path
files=glob.glob1(myPath,"Ptt_Path*")
#Variaveis para armazenamento dos nos
A=nx.Graph()
B=nx.Graph()

o=0;
exists=False;
#Inicia Array node
node = [[0 for x in xrange(3)] for x in xrange(2800000)]

#Laco para leitura dos arquivos de Path
for file in range(0,pttPathCounter):
    #Variavel de armazenamento de cada arquivo de Path
    name = files[file]
    #Variavel de armazenamento dos identificadores dos Ptts (Ex: Ptt_Path_SP - Recupera apenas o identificador SP)
    filename=''.join(e for e in name[9:12] if e.isalnum())
    #Variavel de armazenamento do conteudo dos arquivos de Path
    e1=open('../PTT_PATH/Ptt_Path_'+filename+'.txt', 'r')
    #Leitura atual de arquivo
    print "Processing PTT "+filename+"..."

    #Declaracao de variaveis
    i=0;j=0;

    #Laco para leitura dos arquivos de Path
    for line in e1:
        #Laco para leitura das colunas
        while i <= 1:
	    #Se primeira coluna
            if (i==0):
                #Armazena o AS ID
                node[o][0]=filename
            #Se segunda coluna
            elif(i==1):
                for k in range(0,o+1):
    	            if (str(line.strip().split(' ')[0]) in str(node[k][1]) and filename in str(node[k][0])):
                        exists=True

                if (exists==False):
                     node[o][1] = str(line.strip().split(' ')[0])
                 #    print str(node[o][0])+" "+str(node[o][1])
                     os.system('echo '+str(node[o][0])+" "+str(node[o][1])+'  >> '+file_name)
                     o+=1

            exists=False
            #Incrementa a leitura para uma nova coluna
            i+=1

        #Inicia uma nova linha na coluna 0
        i=0


