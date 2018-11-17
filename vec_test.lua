function love.load()
	class = require("middleclass")
	Vec2 = require("vec2")

	--quick_tests()
	
	vec = Vec2(0, 1) * 50
	
	offset = Vec2(100, 100)

	OMEGA = (math.pi / 2) / 10
end

function love.update(dt)
	vec = vec:rotate(dt)

	local SPEED = Vec2(2 * 60, 1 * 60)
	offset = offset + SPEED * dt
end

function love.draw()
	local x0 = offset.x
	local x = x0 + vec.x
	local y0 = offset.y
	local y = y0 + vec.y
	
	love.graphics.line(x0, y0, x, y)
end
