#!/bin/bash
#################################
# input 1: matrix file
# input 2: profiles (i.e., 1.1, 1.2, ...)
# hash (#) used as profile separators
#################################

echo "Generating plotter.plt"

MATRIX=$1
PROFILE=$2

rm -f plotter.plt 2>/dev/null

x=`grep -v "#" $MATRIX|wc -l`

cat <<EOT >> plotter.plt
set palette grey
set palette negative
set cblabel "Score" font ",20"
set terminal postscript eps enhanced font "Helvetica,17"
#set cbrange [0:6]
#set xlabel "AS index" font ",20"
set tics font ",17"
set output "output.eps"
set xrange[0:$x]
#set yrange[0:$x]
unset xtics
unset colorbox
unset ytics
EOT

#x=`expr $x - 1`
count=0
for prof in `awk '{print $2}' $PROFILE|sort -u`; do
      profile[$count]=$prof
      count=`expr $count + 1`
done

count=1
for line in `grep -n "#" $MATRIX|cut -d: -f1`; do
      line=`expr $line - $count`
      if [ $count -eq 1 ]; then
        echo "set ytics (\"${profile[`expr $count - 1`]}\" $line/2)" >> plotter.plt
	echo "set xtics (\"${profile[`expr $count - 1`]}\" $line/2)" >> plotter.plt
	lastline=$line
      else
        echo "set ytics add (\"${profile[`expr $count - 1`]}\" ($lastline+($line-$lastline+1)/2)-1)" >> plotter.plt
        echo "set xtics add (\"${profile[`expr $count - 1`]}\" ($lastline+($line-$lastline+1)/2)-1)" >> plotter.plt
	lastline=$line	
      fi
      #if [ $line -eq $x ]; then
      #  line=`expr $line - 1`
      #fi
      line=`echo "$line-0.5"|bc`
      echo "set arrow from -1,$line to ${x},$line nohead front ls 1" >> plotter.plt
      echo "set arrow from $line,-1 to $line,${x}-1 nohead front ls 1" >> plotter.plt	
      count=`expr $count + 1`
done
line=`echo "$line+0.5"|bc`
echo "set ytics add (\"${profile[`expr $count - 1`]}\" $line+($x-1-$line)/2)" >> plotter.plt
echo "set xtics add (\"${profile[`expr $count - 1`]}\" $line+($x-1-$line)/2)" >> plotter.plt

tmpfile=matrix.tmp
grep -v "#" $MATRIX > $tmpfile
echo "plot './$tmpfile' matrix notitle with image" >> plotter.plt
