set terminal postscript eps enhanced font "Helvetica,26"
set encoding iso_8859_1

#set size 1.5, 1.5

set boxwidth 0.9 absolute
set border linewidth 2

set xlabel "Profundidade" font ",24"
set ylabel "Frequencia (%)" font ",24" offset 1
set tics font ",22"

set style fill pattern
set bars front

set style data histogram
set style histogram cluster gap 1

set xrange [-0.5:6.5]
set yrange [2:60]

set output "Distribução_Profundidade_v2.eps"
plot 'lg.df.ptt.br/DF_Distribução_Profundidade.csv' using 2 : xtic(1) fs pattern 1 t "DF" lt 1 lw 3 lc rgb "red", 'lg.mg.ptt.br/MG_Distribução_Profundidade.csv' using 2 : xtic(1) fs pattern 3 t "MG" lt 1 lw 3 lc rgb "blue", 'lg.sp.ptt.br/SP_Distribução_Profundidade.csv' using 2 : xtic(1) fs pattern 0 t "SP" lt 1 lw 3 lc rgb "red", 'lg.vix.ptt.br/VIX_Distribução_Profundidade.csv' using 2 : xtic(1) fs pattern 2 t "VIX" lt 1 lw 3 lc rgb "blue"  
