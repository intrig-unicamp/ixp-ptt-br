set terminal postscript eps enhanced font "Helvetica,26"
set encoding iso_8859_1

#set size 1.5, 1.5

#set key right bottom
set xlabel "k" font ",24"
set ylabel "Max Community Size" font ",24"
set tics font ",24"

set output "sizeCommunity.eps"

set boxwidth 0.9 absolute
set border linewidth 2

set style fill pattern
#set bars front

set style data histogram
set style histogram cluster gap 1

#set xtics border in scale 0,0 nomirror rotate by -45

#set key bmargin center horizontal Right noreverse noenhanced autotitle columnhead nobox
#set style histogram clustered gap 1 title textcolor lt -1 font ",24"  offset character 0.5, 0.1, 0

plot 'data_all.txt' using 2:xtic(1) t "Number of ASes" lt 1 lw 3 lc rgb "red" with lp, \
	newhistogram, 'data_all.txt' using 4:xtic(1) notitle fs pattern 1 lt 1 lw 3 lc rgb "red"
	

#set pointsize 4
#plot 'data_all.txt' using 1:2 t "Number of ASes" lt 1 lw 3 lc rgb "red" with lp
