#!/usr/bin/env python

#import zipfile, cStringIO
import networkx as nx
import matplotlib.pyplot as plt
import math
import os
import glob
from networkx import *
from operator import itemgetter, attrgetter, methodcaller

#Nome do arquivo de saida a ser gerado
file_name="report_amount_of_prepends.txt"
#Remove o arquivo de saida se ja existir
os.system('rm '+ file_name)
#Caminho dos arquivos de Prepend a serem lidos
myPath="../PTT_PREPEND"
#Contador da quantidade de arquivos de Prepend
pttPathCounter = len(glob.glob1(myPath,"Ptt_Prepend*"))
#Armazena em Array o nome dos arquivos de Prepend
files=glob.glob1(myPath,"Ptt_Prepend*")

#Laco para leitura dos arquivos de Path
for file in range(0,pttPathCounter):
    #Variavel de armazenamento de cada arquivo de Prepend
    name = files[file]
    #Variavel de armazenamento dos identificadores dos Ptts (Ex: Ptt_Prepend_SP
    filename=''.join(e for e in name[12:15] if e.isalnum())
    #Variavel de armazenamento do conteudo dos arquivos de Path
    e1=open('../PTT_PREPEND/Ptt_Prepend_'+filename+'.txt', 'r')
    #Leitura atual de arquivo
    print "Processing PTT "+filename+"..."

    i=0;k=1;j=0;p1=0;nPrepends=0;
    node = [[0 for x in xrange(120)] for x in xrange(2800000)]

    for line in e1:
        count=len(line.strip().split(' '))
        while i <= count:
            if (i==0):
                node[j][i]=26121
            elif((i>0) and (node[j][k-1]!=int(line.strip().split(' ')[i-1]))):
                node[j][k] = int(line.strip().split(' ')[i-1])
	        k+=1
            elif(node[j][k-1]==int(line.strip().split(' ')[i-1]) and node[j][k-1]!=0 and j>=p1):
	        nPrepends=nPrepends+(node[j][1])
             #   print node[j][1]
	       # nPrepends=nPrepends+1
	        p1=j+1;
            i+=1
        i=0
        k=1
        j+=1

    #-----------------------------------------------------------------------
    #---Quantidade de prepends------
    print "PTT "+filename+" OK!"
    print str(nPrepends)
    os.system('echo "Amount of prepends " '+filename+'":" '+str(nPrepends)+' >>'+file_name)
    #--------------------------

