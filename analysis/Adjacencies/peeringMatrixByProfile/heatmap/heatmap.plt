set palette rgbformulae -7,2,-7
set datafile separator ","

set cblabel "Score" font ",20"
set terminal postscript eps enhanced color font "Helvetica,20"
set tics font ",17"
set output "heatmap.eps"

set xtics ("1.1" 0)
set xtics add ("1.2" 1)
set xtics add ("2.1" 2)
set xtics add ("2.2" 3)
set xtics add ("3.1" 4)
set xtics add ("3.2" 5)
set xtics add ("3.3" 6)
set xtics add ("4.1" 7)
set xtics add ("4.2" 8)
set xtics add ("4.3" 9)

set ytics ("1.1" 0)
set ytics add ("1.2" 1)
set ytics add ("2.1" 2)
set ytics add ("2.2" 3)
set ytics add ("3.1" 4)
set ytics add ("3.2" 5)
set ytics add ("3.3" 6)
set ytics add ("4.1" 7)
set ytics add ("4.2" 8)
set ytics add ("4.3" 9)

set cbrange [0:5]
set cblabel "Score"
set view map
splot 'data' matrix with image
