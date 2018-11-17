local PBullet = class("Bullet")

local Vec2 = require("vec2")
local Trail = require("trail")
local Body = require("collision")

local MOVE_SPEED = 10 * 60
local IMAGE-- = love.graphics.newImage("gfx/player-bullet.png")

function PBullet:set_image(image)
	self.image = image
	self.trail = Trail(self.image)
end

function PBullet:init(pos, dir)
	self.pos = Vec2(pos)
	self.dir = Vec2(dir)
	self.body = Body(self.pos.x, self.pos.y, 10, 10)
	--self.trail = Trail(IMAGE, true)
end

function PBullet:update(dt)
	if self.trail then
		self.trail:update(self.pos, dt)
	end

	self.pos = self.pos + self.dir * MOVE_SPEED * dt
	self.pos = Vec2(math.floor(self.pos.x), math.floor(self.pos.y))
	self.body:move(self.pos:unpack())
end

function PBullet:draw()
	if self.trail then
		self.trail:draw(5, 5)
	end
	love.graphics.draw(self.image, self.pos.x, self.pos.y)
	self.body:draw({0, 1, 1})
end

function PBullet:is_dead()
	if self.dead then return true end
	
	if self.pos.x > love.graphics.getWidth() or self.pos.x < 0 then
		return true
	end

	if self.pos.y > love.graphics.getHeight() or self.pos.y < 0 then
		return true
	end

	return false
end

return PBullet
