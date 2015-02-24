set terminal postscript eps enhanced font "Helvetica,26"
set encoding iso_8859_1

#set size 1.5, 1.5

set border linewidth 2

set pointsize 3
set key right bottom
set xrange [1:7.5]
set xlabel "Profundidade" font ",24"
set ylabel "CDF" font ",24" offset 2
set tics font ",22"


set output "profundidade_x_CDF_resumo.eps"

plot "lg.df.ptt.br/DF_Profundidade_x_CDF.csv" using 1:2 title "DF" with linespoints lt 2  lw 3 pt 10 lc rgb "red", "lg.mg.ptt.br/MG_Profundidade_x_CDF.csv" using 1:2 title "MG" with linespoints lt 2  lw 3 pt 6 lc rgb "blue", "lg.sp.ptt.br/SP_Profundidade_x_CDF.csv" using 1:2 title "SP" with linespoints lt 1  lw 3 pt 9 lc rgb "red", "lg.vix.ptt.br/VIX_Profundidade_x_CDF.csv" using 1:2 title "VIX" with linespoints lt 1  lw 3 pt 7 lc rgb "blue" 
