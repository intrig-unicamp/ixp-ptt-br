set terminal postscript eps enhanced font "Helvetica,26"
set encoding iso_8859_1

#set size 1.5, 1.5
set border linewidth 2
#set pointsize 4

#set key right bottom
set xlabel "k" font ",24"
set ylabel "Out Degree Fraction" font ",24"
set tics font ",24"
set xtics 1
set ytics 0.1
set style fill pattern

#set yrange [0:.6]
#set xrange [2.5:6.5]
#set arrow from 2.5,1 to 6.5,1 ls 2

set output "odfCommunity.eps"

plot 'densityAvgODF_all.txt' using 1:3 notitle pt 7
