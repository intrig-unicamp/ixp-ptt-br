set terminal postscript eps enhanced font "Helvetica,30"
set encoding iso_8859_1

set size 1.5, 1.5
set border linewidth 2
set pointsize 4

#set key right bottom
set xlabel "k" font ",30"
set ylabel "ODF" font ",30"
set tics font ",27"
set xtics 1
set ytics 0.1
set style fill pattern

set yrange [0:.6]
set xrange [2.5:6.5]
#set arrow from 2.5,1 to 6.5,1 ls 2

set output "odfCommunity.eps"

plot 'odf_es' using 1:2 t "VIX" lt 1 lw 3 pt 9 lc rgb "red" with lp, \
'odf_mg' using 1:2 t "MG" lt 1 lw 3 pt 6 lc rgb "blue" with lp, \
'odf_df' using 1:2 t "DF" lt 2 lw 3 pt 10 lc rgb "red" with lp, \
'odf_bel' using 1:2 t "BEL" lt 2 lw 3 pt 2 lc rgb "blue" with lp

################# Com intervalo de confianca:
#plot 'densityODF_es' using 1:2:($2-$4):($2+$4) t "ES" lw 3 pt 9 lc rgb "red" with yerrorbars, \
'densityODF_mg' using 1:2:($2-$4):($2+$4) t "MG" lw 3 pt 9 lc rgb "blue" with yerrorbars, \
'densityODF_df' using 1:2:($2-$4):($2+$4) t "DF" lw 3 pt 10 lc rgb "red" with yerrorbars, \
'densityODF_bel' using 1:2:($2-$4):($2+$4) t "BEL" lw 3 pt 9 lc rgb "blue" with yerrorbars


