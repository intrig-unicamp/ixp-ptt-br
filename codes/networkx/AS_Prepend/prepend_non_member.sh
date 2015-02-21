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
file_name="report_nprepends_non_member_.txt"
#Remove o arquivo de saida se ja existir
os.system('rm '+ file_name)
#Caminho dos arquivos de Path a serem lidos
myPath="../PTT_PATH"
#Contador da quantidade de arquivos de Path
pttPathCounter = len(glob.glob1(myPath,"Ptt_Path*"))
#Armazena em Array o nome dos arquivos de Path
files=glob.glob1(myPath,"Ptt_Path*")

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

    #Variaveis para armazenamento dos nos
    G=nx.Graph()
    A=nx.Graph()
    T=nx.Graph()
#-----------------------------------------------------------------------
    #Declaracao de variaveis
    i=0;k=1;j=0;
    #Inicia Array node
    node = [[0 for x in xrange(120)] for x in xrange(2800000)]

    #Laco para leitura dos arquivos de Path
    for line in e1:
        #Numero de colunas por linha dos arquivos de Path
        count=len(line.strip().split(' '))
        #Laco para leitura das colunas
        while i <= count:
            #Insere o ASN 26121 representando um PTT - Todos os PTTs Brasil possuem esse ASN
            if (i==0):
                #Armazena o ASN 26121
                node[j][i]=26121
                #Adiciona em T o no 26121
	        T.add_node(node[j][i])
            #Se coluna > 0 e a coluna de leitura atual nao for igual a coluna seguinte...
            elif((i>0) and (node[j][k-1]!=int(line.strip().split(' ')[i-1]))):
                #Armazena o No
                node[j][k] = int(line.strip().split(' ')[i-1])
		#Adiciona em T o No
	        T.add_node(node[j][i])
                #Percorre para a coluna seguinte
	        k+=1
            #Se coluna > 1 e o no de leitura atual for igual ao no da coluna seguinte e este no for diferente de 0...
            elif((i>1) and node[j][k-1]==int(line.strip().split(' ')[i-1]) and node[j][k-1]!=0):
		#Adiciona o no em G como no de Prepend
	        G.add_node(node[j][k-1])
            #Se o ASN for membro do PTT...
            if(i==1):
                #Armazena o membro do PTT
	        A.add_node(node[j][i])
            #Incrementa a leitura para uma nova coluna
            i+=1
        #Inicia uma nova linha na coluna 0
        i=0
        #Inicia uma nova linha na coluna 0
        k=1
        #Leitura de uma nova linha
        j+=1

    #-----------------------------------------------------------------------
    #---Quantidade de prepends------
    print "PTT "+filename+" OK!"
    if 0 in T.nodes():
        T.remove_node(0)
    G.remove_nodes_from(A)
    os.system('echo "Number of prepends non members " '+filename+'":" '+str(len(G.nodes()))+' "of" '+str(len(T.nodes()))+' "Total ASNs"  >> '+file_name)
    os.system('echo "ASes: "'+str(sorted(G.nodes()))+' >> '+file_name)
    #--------------------------
