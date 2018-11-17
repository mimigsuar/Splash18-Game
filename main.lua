function love.load()
	class = require("middleclass")
	local Game = require("game")

	game = Game()

	game:start()
end

function love.update(dt)
	game:update(dt)
end

function love.keypressed(key)
	if key == "t" then
		local Trail = require("trail")
		Trail.disabled = not Trail.disabled
	end
end


function love.draw()
	game:draw()
end
