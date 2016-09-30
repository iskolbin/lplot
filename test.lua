local plot = require('plot')
local luabox = require('luabox')

local w, h = 1, 1

local x0, y0, x1, y1 = 1, 1, 1, 1
local playerx, playery = 1, 1
local log = {}
local mode = 'line'

local function addlog( v )
	table.insert( log, v )
end

local function render()
	luabox.setcell( '@', playerx, playery, 0, luabox.rgbf( 1, 0, 0 )) 
	luabox.present()
end

local running = true

local function plotl( x, y, v )
	luabox.setcell( '*', x, y, 0, luabox.grayf( v ))
end

local function ploth( x, y, v )
	luabox.setcell( ' ', x, y, 0, luabox.rgbf( v, 0, 0 ))
end

local function plotm( x, y, v )
	luabox.setcell( ' ', x, y, 0, luabox.grayf( v ))
end

local function plots( x, y, v )
	luabox.setcell( ' ', x, y, 0, luabox.grayf( v * 0.75 ))
end

local function drawclock()
	local cx, cy = math.floor(w/2), math.floor(h/2)
	local hs, ms, ss = os.date('%H,%M,%S'):gmatch( '(%d+),(%d+),(%d+)', tonumber )()
	local ahs, ams, ass = (hs % 12) * 2*math.pi/12, (hs % 60) * 2*math.pi/60, (ss % 60) * 2*math.pi/60
	local minr = math.min( cx, cy )
	local rh, rm, rs = math.floor( minr * 0.33 ), math.floor( minr * 0.66), math.floor( minr * 0.99 ) 
	plot.ellipse( plotl, x0, y0, w-1, h-1 )
	plot.lineaa( plots, cx, cy, math.floor(cx+rs*math.cos(ass)), math.floor(cy+rs*math.sin(ass)))
	plot.lineaa( plotm, cx, cy, math.floor(cx+rm*math.cos(ams)), math.floor(cy+rm*math.sin(ams)))
	plot.lineaa( ploth, cx, cy, math.floor(cx+rh*math.cos(ahs)), math.floor(cy+rh*math.sin(ahs)))
end

local function updatedraw()
	local x0, y0 = math.floor(w/2), math.floor(h/2) 
	if mode == 'line' then
		plot.line( plotl, playerx, playery, x0, y0 )
	elseif mode == 'circle' then
		plot.circle( plotl, x0, y0, math.floor( ((x0-playerx)^2 + (y0-playery)^2)^0.5))
	elseif mode == 'ellipse' then
		plot.ellipse( plotl, x0, y0, playerx, playery )
	elseif mode == 'lineaa' then
		plot.lineaa( plotl, playerx, playery, x0, y0 )
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
	if key == luabox.ESC then
		running = false
		return 
	elseif key == luabox.LEFT then
		playerx = playerx - 1
	elseif key == luabox.RIGHT then
		playerx = playerx + 1
	elseif key == luabox.UP then
		playery = playery - 1
	elseif key == luabox.DOWN then
		playery = playery + 1
	elseif key == luabox.SPACE then
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

luabox.init( luabox.INPUT_CURRENT, luabox.OUTPUT_256 )
luabox.setcallback( luabox.EVENT_KEY, onkey )
luabox.setcallback( luabox.EVENT_RESIZE, onresize )

w, h = luabox.width(), luabox.height()
while running do
	luabox.clear()
	update()
	render()
	luabox.peek()
end

luabox.shutdown()

print( table.concat( log, '\n' ))
