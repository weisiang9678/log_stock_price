reset
set terminal pngcairo dashed enhanced size 480,360 font 'arial,12' fontscale 1.0
set encoding utf8

set output 'plot.png'
set xrange [0.0:1.0]
set yrange [0.0:100.0]
set xlabel "{/Arial:Bold Time (year)}"
set ylabel "{/Arial:Bold Stock Price ($)}"

plot for [i=1:100:1] 'output_'.i.'.txt' u 1:2 w l notitle,\
     'deterministic.txt' u 1:2 lt 1 lw 4.0 lc "black" w l notitle,\
     'deterministic.txt' u 1:3 lt 1 lw 4.0 lc "black" w l notitle,\
     'deterministic.txt' u 1:4 lt 1 lw 4.0 lc "black" w l notitle,\