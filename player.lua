local Player = class("Player")

local Vec2 = require("vec2")
local Trail = require("trail")
local Bullet = require("bullet")
local Body = require("collision")

local IMAGE = love.graphics.newImage("gfx/player.png")
local BULLET_IMAGE = love.graphics.newImage("gfx/player-bullet.png")
local MOVE_SPEED = 5 * 60
local FIRE_RATE = 0.2

function Player:init()
	self.width = 40
	self.height = 40
	self.pos = Vec2()
	self.pos.x = love.graphics.getWidth() / 2 - self.width / 2
	self.pos.y = love.graphics.getHeight() / 2 - self.height / 2
	self.bullets = {}
	self.trail = Trail(IMAGE, true)
	self.body = Body(self.pos.x, self.pos.y, self.width, self.height) 
	self.fire_time = FIRE_RATE 
end

function Player:input_controls()
	self.input_dir = Vec2()
	self.fire_dir = Vec2()

	if love.keyboard.isDown("a") then
		self.input_dir.x = -1
	elseif love.keyboard.isDown("d") then
		self.input_dir.x = 1
	else
		self.input_dirx = 0
	end

	if love.keyboard.isDown("w") then
		self.input_dir.y = -1
	elseif love.keyboard.isDown("s") then
		self.input_dir.y = 1
	else
		self.input_dir.y = 0
	end
	
	if love.keyboard.isDown("j") then
		self.fire_dir.x = -1
	elseif love.keyboard.isDown("l") then
		self.fire_dir.x = 1
	else
		self.fire_dir.x = 0
	end

	if love.keyboard.isDown("i") then
		self.fire_dir.y = -1
	elseif love.keyboard.isDown("k") then
		self.fire_dir.y = 1
	else
		self.fire_dir.y = 0
	end

	if self.input_dir:mag2() > 1 then
		self.input_dir:normalize()
	end

	if self.fire_dir:mag2() > 1 then
		self.fire_dir:normalize()
	end
end

function Player:fire_bullet()
	if #self.bullets < 6 and self.fire_time >= FIRE_RATE then
		local b = Bullet(self.pos + Vec2(15, 15), self.fire_dir)
		b:set_image(BULLET_IMAGE)
		table.insert(self.bullets, b)
		self.fire_time = 0
	end
end

function Player:update(dt)
	self.pos.x = math.floor(self.pos.x)
	self.pos.y = math.floor(self.pos.y)
	
	self.trail:update(self.pos, dt)
	
	self:input_controls()

	if self.fire_time < FIRE_RATE then
		self.fire_time = self.fire_time + dt
	end
	
	if self.fire_dir:mag2() > 0 then
		-- fire a bullet a whatever --
		self:fire_bullet()
	end

	for i=#self.bullets, 1, -1 do
		self.bullets[i]:update(dt)
		
		if self.bullets[i]:is_dead() then
			table.remove(self.bullets, i)
		end
	end

	self.pos = self.pos + self.input_dir * MOVE_SPEED * dt
	self.pos = Vec2(math.floor(self.pos.x), math.floor(self.pos.y))
	self.body:move(self.pos:unpack())
end

function Player:on_collision(other)
	print("player collided with " .. tostring(other))
end

function Player:draw()
	self.trail:draw(self.width / 2, self.height / 2)
	
	for key, bullet in ipairs(self.bullets) do
		bullet:draw()
	end
	
	love.graphics.draw(IMAGE, math.floor(self.pos.x), math.floor(self.pos.y))
	
	self.body:draw({1, 0, 0})
end

return Player
