#set palette rgbformulae -7,2,-7
set palette defined (0 "green", 0.5 "yellow", 1 "red")
set datafile separator ","

set cblabel "Peering Affinity" font ",22"
set terminal postscript eps enhanced color font "Helvetica,20"
set tics font ",17"
set output "heatmap.eps"

set xrange [-0.5:9.5]
set yrange [-0.5:9.5]

set xtics ("1.1" 0.5)
set xtics add ("1.2" 1.5)
set xtics add ("2.1" 2.5)
set xtics add ("2.2" 3.5)
set xtics add ("3.1" 4.5)
set xtics add ("3.2" 5.5)
set xtics add ("3.3" 6.5)
set xtics add ("4.1" 7.5)
set xtics add ("4.2" 8.5)
set xtics add ("4.3" 9.5)

set ytics ("1.1" 0.5)
set ytics add ("1.2" 1.5)
set ytics add ("2.1" 2.5)
set ytics add ("2.2" 3.5)
set ytics add ("3.1" 4.5)
set ytics add ("3.2" 5.5)
set ytics add ("3.3" 6.5)
set ytics add ("4.1" 7.5)
set ytics add ("4.2" 8.5)
set ytics add ("4.3" 9.5)

set cbrange [0:1]
set cblabel "Peering Affinity"
set view map
splot 'normalized_data' matrix with image
#splot 'heatmap_produto_data' matrix with image
#splot 'heatmap_soma_data' matrix with image
