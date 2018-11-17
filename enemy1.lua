local Enemy = require("enemy")
local Body = require("collision")
local Vec2 = require("vec2")

local Enemy1 = class("Enemy1", Enemy)

local IMAGE = love.graphics.newImage("gfx/enemy1.png")
local MAX_SPEED = 6 * 60

function Enemy1:init(pos)
	Enemy.init(self, IMAGE, pos)
	self.speed = love.math.random() * MAX_SPEED
end

function Enemy1:update(dt)
	local player_pos = self:get_player().pos
	local dir = (player_pos - self.pos):normalized()
	
	self.pos = self.pos + (dir * self.speed) * dt
	
	Enemy.update(self, dt)
end

function Enemy1:draw()
	Enemy.draw(self)
	love.graphics.draw(IMAGE, math.floor(self.pos.x), math.floor(self.pos.y))
end

return Enemy1
