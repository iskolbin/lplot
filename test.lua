local Plot = require('Plot')
local Luabox = require('luabox')

local w, h = 1, 1

local x0, y0, x1, y1 = 1, 1, 1, 1
local playerx, playery = 1, 1
local log = {}
local mode = 'line'

local function addlog( v )
	table.insert( log, v )
end

local function render()
	Luabox.setcell( '@', playerx, playery, 0, Luabox.rgbf( 1, 0, 0 )) 
	Luabox.present()
end

local running = true

local function plot( x, y, v )
	Luabox.setcell( '*', x, y, 0, Luabox.grayf( v ))
end

local function ploth( x, y, v )
	Luabox.setcell( ' ', x, y, 0, Luabox.rgbf( v, 0, 0 ))
end

local function plotm( x, y, v )
	Luabox.setcell( ' ', x, y, 0, Luabox.grayf( v ))
end

local function plots( x, y, v )
	Luabox.setcell( ' ', x, y, 0, Luabox.grayf( v * 0.75 ))
end

local function drawclock()
	local cx, cy = math.floor(w/2), math.floor(h/2)
	local hs, ms, ss = os.date('%H,%M,%S'):gmatch( '(%d+),(%d+),(%d+)', tonumber )()
	local ahs, ams, ass = (hs % 12) * 2*math.pi/12, (hs % 60) * 2*math.pi/60, (ss % 60) * 2*math.pi/60
	local minr = math.min( cx, cy )
	local rh, rm, rs = math.floor( minr * 0.33 ), math.floor( minr * 0.66), math.floor( minr * 0.99 ) 
	Plot.ellipse( plot, x0, y0, w-1, h-1 )
	Plot.lineaa( plots, cx, cy, math.floor(cx+rs*math.cos(ass)), math.floor(cy+rs*math.sin(ass)))
	Plot.lineaa( plotm, cx, cy, math.floor(cx+rm*math.cos(ams)), math.floor(cy+rm*math.sin(ams)))
	Plot.lineaa( ploth, cx, cy, math.floor(cx+rh*math.cos(ahs)), math.floor(cy+rh*math.sin(ahs)))
end

local function updatedraw()
	local x0, y0 = math.floor(w/2), math.floor(h/2) 
	if mode == 'line' then
		Plot.line( plot, playerx, playery, x0, y0 )
	elseif mode == 'circle' then
		Plot.circle( plot, x0, y0, math.floor( ((x0-playerx)^2 + (y0-playery)^2)^0.5))
	elseif mode == 'ellipse' then
		Plot.ellipse( plot, x0, y0, playerx, playery )
	elseif mode == 'lineaa' then
		Plot.lineaa( plot, playerx, playery, x0, y0 )
	elseif mode == 'clock' then
		drawclock()
	end
end

local function nextmode()
	if mode == 'line' then
		mode = 'circle'
	elseif mode == 'circle' then
		mode = 'ellipse'
	elseif mode == 'ellipse' then
		mode = 'lineaa'
	elseif mode == 'lineaa' then
		mode = 'clock'
	elseif mode == 'clock' then
		mode = 'line'
	end
end

local function onkey( ch, key, mod )
	if key == Luabox.ESC then
		running = false
		return 
	elseif key == Luabox.LEFT then
		playerx = playerx - 1
	elseif key == Luabox.RIGHT then
		playerx = playerx + 1
	elseif key == Luabox.UP then
		playery = playery - 1
	elseif key == Luabox.DOWN then
		playery = playery + 1
	elseif key == Luabox.SPACE then
		nextmode()
	end
	updatedraw()
end

local function update()
	updatedraw()
end

local function onresize( neww, newh )
	w, h = neww, newh
	render()
end

Luabox.init( Luabox.INPUT_CURRENT, Luabox.OUTPUT_256 )
Luabox.setcallback( Luabox.EVENT_KEY, onkey )
Luabox.setcallback( Luabox.EVENT_RESIZE, onresize )

w, h = Luabox.width(), Luabox.height()
while running do
	Luabox.clear()
	update()
	render()
	Luabox.peek()
end

Luabox.shutdown()

print( table.concat( log, '\n' ))
