#!/usr/bin/env python

import networkx as nx
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np 
import glob
from networkx import *
from operator import itemgetter, attrgetter, methodcaller
import pymc

#Caminho dos arquivos de Path a serem lidos
myPath="../graphics_AS_degree/"
#Contador da quantidade de arquivos de Path
pttPathCounter = len(glob.glob1(myPath,"*.dat"))
#Armazena em Array o nome dos arquivos de Path
files=glob.glob1(myPath,"*.dat")

hatch=""
color=""
ecolor=""
edgecolor=""

#Laco para leitura dos arquivos de Path
for file in range(0,pttPathCounter):
    #Variavel de armazenamento de cada arquivo de Path
    name = files[file]
    print name
    #Variavel de armazenamento dos identificadores dos Ptts (Ex: Ptt_Path_SP - Recupera apenas o id$
    filename=''.join(e for e in name[12:15] if e.isalnum())

    if (filename=="AME"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="/"
    elif (filename=="BA"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="|"
    elif (filename=="BEL"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="-"
    elif (filename=="CAS"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="xx"
    elif (filename=="CE"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="O"
    elif (filename=="CJB"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="X"
    elif (filename=="CPV"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="."
    elif (filename=="CXJ"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch=".."
    elif (filename=="DF"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="x"
    elif (filename=="GYN"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="*"
    elif (filename=="LAJ"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="**"
    elif (filename=="LDA"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="+"
    elif (filename=="MAO"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="++"
    elif (filename=="MGF"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="oo"
    elif (filename=="MG"):
        color='blue'
        ecolor='blue'
        edgecolor='blue'
        hatch="@"
    elif (filename=="NAT"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="@@"
    elif (filename=="PE"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="0"
    elif (filename=="PR"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="/"
    elif (filename=="RJ"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="///"
    elif (filename=="RS"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="o"
    elif (filename=="SCA"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="+++"
    elif (filename=="SC"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="ooo"
    elif (filename=="SJC"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="..."
    elif (filename=="SJP"):
        color='white'
        ecolor='red'
        edgecolor='red'
        hatch="00"
    elif (filename=="SP"):
        color='white'
        ecolor=''
        edgecolor='red'
        hatch=" "
    elif (filename=="VIX"):
        color='white'
        ecolor='blue'
        edgecolor='blue'
        hatch="xxx"

    #Leitura atual de arquivo
    f2 = open(myPath+'degree_plot_'+filename+'.dat', 'r')
    newlines = f2.readlines()
    f2.close()

    # initialize some variable to be lists:
    x1 = []
    y1 = []
    # scan the rows of the file stored in lines, and put the values into some variables:
    for newline in newlines:
        p = newline.split()
        x1.append(float(p[0]))
        y1.append(float(p[1]))
   
    xv = np.array(x1)
    yv = np.array(y1)

    #plt.plot(xv, yv)
    plt.bar(xv, yv, linewidth=1.3, color=color, ecolor=ecolor, edgecolor=edgecolor, hatch=hatch, align='center')
    #plt.bar(x, y, linewidth=1.3, color='#CCCCCC', ecolor='#000000', align='center')
    plt.xticks(xv)
    plt.title("PTT - "+filename)
    plt.xlabel("Number of Neighbors", fontsize=18)
    plt.ylabel("(%) SAs", fontsize=18)
    plt.tick_params(axis='both', which='major', labelsize=14)
    #plt.margins(0.00)
    plt.ylim([0,80])
    plt.margins(0.02, 0.0)
    # now, plot the data:
    print "Processing PTT "+filename+"..."
    plt.savefig("../graphics_AS_degree/Graphic_"+filename+".eps")
    plt.clf()
#    plt.show()
