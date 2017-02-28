Lua plot
========

Lua implementation of simple rasterization algorithms. Based mainly on [C-implementation by Zingl Alois](http://members.chello.at/~easyfilter/bresenham.html). 

All presented functions take plotting function as the first argument. Algorithms pass 3 arguments to plotting function: x and y coordinates and alpha value ( 0 -- minimum, 1 - maximum ). For not antialiased algorithms alpha value is always equals 1. If plotting function returns non-false result then algorithm will halt.

plot.line( f, x0, y0, x1, y1 )
------------------------------
Classic [Bresenham's line algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm). Draws line from **x0,y0** to **x1,y1**.

plot.lineaa( f, x0, y0, x1, y1 )
--------------------------------
Line rasterization [algorithm by Wu](https://en.wikipedia.org/wiki/Xiaolin_Wu%27s_line_algorithm). Draws antialiased line from **x0,y0** to **x1,y1**.

plot.circle( f, x0, y0, radius )
--------------------------------
Midpoint circle algorithm. Draws circle centred in **x0**, **y0** with specified **radius**.

plot.ellipse( f, x0, y0, x1, y1 )
---------------------------------
Draws ellipse bounded by rectangle **x0,y0,x1,y1**. 
