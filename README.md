Plot
====

Lua implementation of simple rasterization algorithms. Based mainly on C-implementation by Zingl Alois, see http://members.chello.at/~easyfilter/bresenham.html. All presented functions take plotting function as the first argument. Plotting function must process 3 arguments: x and y coordinates and alpha value ( 0 -- minimum, 1 - maximum ). For not antialiased algorithms alpha value is always equals 1.

Plot.line( f, x0, y0, x1, y1 )
------------------------------
Classic Bresenham's line algorithm. Draws line from **x0,y0** to **x1,y1**.

Plot.lineaa( f, x0, y0, x1, y1 )
--------------------------------
Line rasterization algorithm by Wu. Draws antialiased line from **x0,y0** to **x1,y1**.

Plot.circle( f, x0, y0, radius )
--------------------------------
Midpoint circle algorithm. Draws circle centred in **x0**, **y0** with specified **radius**.

Plot.ellipse( f, x0, y0, x1, y1 )
---------------------------------
Draws ellipse bounded by rectangle **x0,y0,x1,y1**. 
