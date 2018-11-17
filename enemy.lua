local Enemy = class("Enemy")

local Vec2 = require("vec2")
local Body = require("collision")
local Trail = require("trail")

function Enemy:init(img, pos)
	self.width = 40
	self.height = 40
	self.pos = Vec2(pos)
	self.body = Body(self.pos.x, self.pos.y, self.width, self.height)
	self.trail = Trail(img, true)
end

function Enemy:draw()
	self.trail:draw(20, 20)

	self.body:draw({0, 0, 1})
end

function Enemy:update(dt)
	self.trail:update(self.pos, dt)
	self.body:move(math.floor(self.pos.x), math.floor(self.pos.y))
end

function Enemy:get_player()
	return self.parent.player
end

function Enemy:is_dead()
	if self.dead then return true end

	return false
end

return Enemy
