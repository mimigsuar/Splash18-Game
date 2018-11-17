local Enemy = require("enemy")
local Vec2 = require("vec2")
local Bullet = require("bullet")

local Enemy2 = class("Enemy2", Enemy)

local IMAGE = love.graphics.newImage("gfx/enemy2.png")
local BULLET_IMAGE = love.graphics.newImage("gfx/enemy-bullet.png")
local SPEED = 2 * 60

local FIRE_RATE = 1

function Enemy2:init(pos)
	Enemy.init(self, IMAGE, pos)
	self.dir = Vec2()
	
	self.fire_time = FIRE_RATE
	self.bullets = {}
end

function Enemy2:get_player_dir()
	return (self:get_player().pos - self.pos):normalized()
end

function Enemy2:fire()
	local b = Bullet(self.pos + Vec2(20, 30), self:get_player_dir())
	b:set_image(BULLET_IMAGE)
	table.insert(self.parent.enemies, b)
end

function Enemy2:update(dt)
	if self.dir:mag2() == 0 then
		self.dir = self:get_player_dir()
	end

	self.pos = self.pos + (self.dir * SPEED) * dt
	
	if self.fire_time < FIRE_RATE then
		self.fire_time = self.fire_time + dt
	else
		self.fire_time = 0
		self:fire()
	end

	if self.pos.x < -120 or self.pos.x > love.graphics.getWidth() + 120 then
		self.dead = true
	elseif self.pos.y < -120 or self.pos.y > love.graphics.getHeight() + 120 then
		self.dead = true
	end

	Enemy.update(self, dt)
end

function Enemy2:draw()
	Enemy.draw(self)
	
	love.graphics.draw(IMAGE, math.floor(self.pos.x), math.floor(self.pos.y))
end

return Enemy2
