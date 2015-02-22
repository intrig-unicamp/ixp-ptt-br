set terminal postscript eps enhanced font "Helvetica,30"
set encoding iso_8859_1

set size 1.5, 1.5
set border linewidth 2
set pointsize 4

#set key right bottom
set xlabel "k" font ",30"
set ylabel "Quantidade de SAs" font ",30"
set tics font ",27"

set style fill pattern

#SIZE ou quantidade de SAs range(3,4)
#set xtics 1
#set xrange [2.5:4.5]
#set output "sizeCommunity_a.eps"
#plot 'data_es' using 1:2 t "VIX" lt 1 lw 3 pt 7 lc rgb "blue", \
'data_mg' using 1:2 t "MG" lt 1 lw 3 pt 6 lc rgb "blue", \
'data_df' using 1:2 t "DF" lt 2 lw 3 pt 10 lc rgb "red", \
'data_bel' using 1:2 t "BEL" lt 2 lw 3 pt 2 lc rgb "black"

#SIZE ou quantidade de SAs range(5,10)
#set xtics 1
#set xrange [4.5:10.5]
#set output "sizeCommunity_b.eps"
#plot 'data_es' using 1:2 t "VIX" lw 3 pt 9 lc rgb "red", 'data_mg' using 1:2 t "MG" lt 2 lw 3 pt 6 lc rgb "blue",'data_df' using 1:2 t "DF" lw 3 pt 10 lc rgb "red", 'data_bel' using 1:2 t "BEL" lt 2 lw 3 pt 2 lc rgb "blue"


#Quantidade de comunidades range(3,4)
set xtics 1
set xrange [2.5:4.5]
set output "numberCommunities_a.eps"
set ylabel "Quantidade de comunidades" font ",30"
plot 'data_es' using 1:3 t "VIX" lt 1 lw 3 pt 7 lc rgb "blue", \
'data_mg' using 1:3 t "MG" lt 1 lw 3 pt 6 lc rgb "blue", \
'data_df' using 1:3 t "DF" lt 2 lw 3 pt 10 lc rgb "red", \
'data_bel' using 1:3 t "BEL" lt 2 lw 3 pt 2 lc rgb "black"


#Quantidade de comunidades range(5,10)
#set xtics 1
#set xrange [4.5:10.5]
#set output "numberCommunities_b.eps"
#set ylabel "Quantidade de comunidades" font ",30"
#plot 'data_es' using 1:3 t "VIX" lw 3 pt 9 lc rgb "red", 'data_mg' using 1:3 t "MG" lt 2 lw 3 pt 6 lc rgb "blue",'data_df' using 1:3 t "DF" lw 3 pt 10 lc rgb "red", 'data_bel' using 1:3 t "BEL" lt 2 lw 3 pt 2 lc rgb "blue"

#tamanho maximo de uma comunidade range(3,4)
#set xtics 1
#set xrange [2.5:4.5]
#set output "maxSizeCommunities_a.eps"
#set ylabel "Tamanho em SAs da maior comunidade" font ",30"
#plot 'data_es' using 1:4 t "VIX" lw 3 pt 9 lc rgb "red", 'data_mg' using 1:4 t "MG" lt 2 lw 3 pt 6 lc rgb "blue",'data_df' using 1:4 t "DF" lw 3 pt 10 lc rgb "red", 'data_bel' using 1:4 t "BEL" lt 2 lw 3 pt 2 lc rgb "blue"

#tamanho maximo de uma comunidade range(5,7)
#set xtics 1
#set xrange [4.5:7.5]
#set output "maxSizeCommunities_b.eps"
#set ylabel "Tamanho em SAs da maior comunidade" font ",30"
#plot 'data_es' using 1:4 t "VIX" lw 3 pt 9 lc rgb "red", 'data_mg' using 1:4 t "MG" lt 2 lw 3 pt 6 lc rgb "blue",'data_df' using 1:4 t "DF" lw 3 pt 10 lc rgb "red", 'data_bel' using 1:4 t "BEL" lt 2 lw 3 pt 2 lc rgb "blue"

#tamanho maximo de uma comunidade range(8,10)
set xtics 1
set xrange [7.5:10.5]
set yrange [5:35]
set output "maxSizeCommunities_c.eps"
set ylabel "Tamanho em SAs da maior comunidade" font ",30"
plot 'data_es' using 1:4 t "VIX" lt 1 lw 3 pt 7 lc rgb "blue", \
'data_mg' using 1:4 t "MG" lt 1 lw 3 pt 6 lc rgb "blue", \
'data_df' using 1:4 t "DF" lt 2 lw 3 pt 10 lc rgb "red", \
'data_bel' using 1:4 t "BEL" lt 2 lw 3 pt 2 lc rgb "black"

