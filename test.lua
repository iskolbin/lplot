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
	Luabox.setcell( '@', playerx, playery, 0, Luabox.rgb( 1, 0, 0 )) 
	Luabox.present()
end

local running = true

local function plot( x, y, v )
	Luabox.setcell( '*', x, y, 0, Luabox.gray( v ))
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
	end
end

local function nextmode()
	if mode == 'line' then
		mode = 'circle'
	elseif mode == 'circle' then
		mode = 'ellipse'
	elseif mode == 'ellipse' then
		mode = 'lineaa'
	else
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
	addlog( 'w=' .. w .. ' h=' .. h )
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
