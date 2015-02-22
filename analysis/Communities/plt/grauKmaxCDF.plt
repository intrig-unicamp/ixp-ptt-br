set terminal postscript eps enhanced font "Helvetica,26"
set encoding iso_8859_1

set pointsize 3
set key right bottom
#set xrange [0.5:6.5]
set yrange [0:100]
set xlabel "Grau de SAs em k-max" font ",24"
set ylabel "CDF" font ",24"
set tics font ",22"


set output "grauKmax_CDF_mg.eps"
plot "grauKmax_mg" using 4:xtic(2) notitle with linespoints lt 1  lw 3 pt 7 lc rgb "blue" 

