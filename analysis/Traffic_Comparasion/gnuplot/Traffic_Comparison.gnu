set terminal postscript eps enhanced font "Helvetica,26"
set encoding iso_8859_1

#set size 1.5, 1.5

set boxwidth 0.9 absolute
set border linewidth 2

set xlabel "" font ",24"
set ylabel "Gbits per Second" font ",24" offset 1
set tics font ",22"

set style fill pattern
set bars front

set style data histogram
set style histogram cluster gap 1

#set xrange [-0.5:6.5]
#set yrange [2:60]

set xtics border in scale 0,0 nomirror rotate by -45  autojustify

#
set key bmargin center horizontal Right noreverse noenhanced autotitle columnhead nobox
set style histogram clustered gap 1 title textcolor lt -1 font ",24"  offset character 0.5, 0.1, 0
#

set output "Traffic_Comparison.eps"
plot newhistogram "Throughput Maximum", \
  'Traffic_Comparison.dat' using 2 : xtic(1) fs pattern 1 lt 1 lw 3 lc rgb "red", \
  '' u 3 fs pattern 3 lt 1 lw 3 lc rgb "blue", \
  '' u 7 fs pattern 0 lt 1 lw 3 lc rgb "red", \
  '' u 8 fs pattern 2 lt 1 lw 3 lc rgb "blue",\
  newhistogram "Throughput Average", \
  '' using 10 : xtic(1) fs pattern 1 t "" lt 1 lw 3 lc rgb "red", \
  '' u 11 fs pattern 3 t "" lt 1 lw 3 lc rgb "blue", \
  '' u 15 fs pattern 0 t "" lt 1 lw 3 lc rgb "red", \
  '' u 16 fs pattern 2 t "" lt 1 lw 3 lc rgb "blue"
  