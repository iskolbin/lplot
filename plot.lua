-- Lua implementation of simple rasterization algorithms. 
-- 
-- Based mainly on C-implementation by Zingl Alois, 
-- see http://members.chello.at/~easyfilter/bresenham.html. 
--
-- All presented functions take a plotting function f as the first argument. 
-- Algorithms pass 3 parameters to a plotting function:
-- x and y coordinates and alpha value ( 0 -- minimum, 1 - maximum ), 
-- for not antialiased algorithms alpha value is always equals 1.
-- If plotting function return non-false result then algorithm will halt.
--
-- coded by Ilya Kolbin ( iskolbin@gmail.com )

local abs, floor = math.abs, math.floor

local plot = {}

-- Bresenham's line algorithm
-- https://en.wikipedia.org/wiki/plot%27s_line_algorithm
function plot.line( f, x0, y0, x1, y1 )
	local dx, sx = abs( x1 - x0 ), x0 < x1 and 1 or -1
	local dy, sy = -abs( y1 - y0 ), y0 < y1 and 1 or -1
	local err, e2 = dx + dy, 0

	while true do	
		f( x0, y0, 1 )
		if x0 == x1 and y0 == y1 then
			break
		else
			e2 = err + err
			if e2 >= dy then
				err, x0 = err + dy, x0 + sx
			end
			
			if e2 <= dx then
				err, y0 = err + dx, y0 + sy
			end
		end
	end
end

-- Midpoint circle algorithm
-- see https://en.wikipedia.org/wiki/Midpoint_circle_algorithm
function plot.circle( f, x0, y0, r )
	local x, y, err = -r, 0, 2 - 2*r -- II. Quadrant 
	repeat
		if f( x0 - x, y0 + y, 1 ) -- I. Quadrant
		or f( x0 - y, y0 - x, 1 ) -- II. Quadrant
		or f( x0 + x, y0 - y, 1 ) -- III. Quadrant
		or f( x0 + y, y0 + x, 1 ) -- IV. Quadrant
		then 
			return 
		end

		r = err
	
		if r <= y then
			y = y + 1
			err = err + y + y + 1 -- e_xy+e_y < 0
		end

		if r > x or err > y then
			x = x + 1
			err = err + x + x + 1 -- e_xy+e_x > 0 or no 2nd y-step
		end
	until x > 0 
end

function plot.ellipse( f, x0, y0, x1, y1 )
	local a, b = abs( x1-x0 ), abs( y1-y0 ) -- values of diameter
	local b1 = b % 2
	local dx, dy = 4*(1-a)*b*b, 4*(b1+1)*a*a -- error increment
	local err, e2 = dx+dy+b1*a*a, 0 --

	if x0 > x1 then 
		x0 = x1 
		x1 = x1 + a
	end -- if called with swapped points

	if y0 > y1 then
		y0 = y1 -- .. exchange them
	end
		
	y0 = y0 + floor(0.5*(b + 1)) 
	y1 = y0 - b1 -- starting pixel
	a = 8*a*a 
	b1 = 8*b*b

	repeat
		if f( x1, y0, 1 ) -- I. Quadrant
		or f( x0, y0, 1 ) -- II. Quadrant
		or f( x0, y1, 1 ) -- III. Quadrant
		or f( x1, y1, 1 ) -- IV. Quadrant
		then
			return
		end

		e2 = err + err
		if e2 <= dy then
			y0 = y0 + 1
			y1 = y1 - 1
			dy = dy + a
			err = err + dy -- y step
		end
		if e2 >= dx or (err + err) > dy then
			x0 = x0 + 1
			x1 = x1 - 1
			dx = dx + b1
			err = err + dx -- x step
		end
	until x0 > x1

	while y0 - y1 < b do  -- too early stop of flat ellipses a=1
		if f( x0 - 1, y0, 1 ) -- finish tip of ellipse
		or f( x1 + 1, y0, 1 ) 
		or f( x0-1, y1, 1 )
		or f( x1+1, y1, 1 )
		then
			return
		end

		y0 = y0 + 1
		y1 = y1 - 1
	end
end

-- Xiaolin Wu's line algorithm
-- https://en.wikipedia.org/wiki/Xiaolin_Wu%27s_line_algorithm
function plot.lineaa( f, x0, y0, x1, y1 )
	local dx, sx = abs( x1 - x0 ), x0 < x1 and 1 or -1
	local dy, sy = abs( y1 - y0 ), y0 < y1 and 1 or -1
	local err = dx - dy
	local ed = (dx + dy == 0) and 1 or ( (dx*dx + dy*dy)^0.5 )

	while true do	
		if f( x0, y0, 1 - abs( err-dx+dy ) / ed ) then
			return
		end
		local e2, x2 = err, x0
		if e2 + e2 >= -dx then
			if x0 == x1 then
				break
			end
			if e2 + dy < ed then
				if f( x0, y0+sy, 1 - (e2+dy) / ed ) then
					return
				end
			end
			err = err - dy
			x0 = x0 + sx
		end
		
		if e2 + e2 <= dy then
			if y0 == y1 then
				break
			end
			if dx - e2 < ed then
				if f( x2+sx, y0, 1 - (dx-e2) / ed ) then
					return
				end
			end
			err = err + dx
			y0 = y0 + sy 
		end
	end
end

return plot
