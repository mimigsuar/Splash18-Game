-- Controls the ENTIRE game --
-- a bit of a god object, but who cares? --

local Game = class("Game")
local Vec2 = require("vec2")
local Player = require("player")
local EnemyList = {
	require("enemy1"),
	require("enemy2")
}

--local ENEMY_SPAWN_TIME = 4
local ENEMY_SPAWN_TIME_MIN = 0.5
local ENEMY_SPAWN_TIME_RATE = 0.2 * 60

function Game:init()
	self.enemies = {}
	self.player = nil
end

function Game:start()
	self.enemies = {}
	self.player = Player()
	self.score = 0
	self.enemy_spawn_timer = 0
	self.enemy_spawn_time = 4

end

function Game:update(dt)
	if self.enemy_spawn_timer < self.enemy_spawn_time then
		self.enemy_spawn_timer = self.enemy_spawn_timer + dt
	else
		self:spawn_enemy()
		self.enemy_spawn_timer = 0
		self.enemy_spawn_time = self.enemy_spawn_time - ENEMY_SPAWN_TIME_RATE * dt
		if self.enemy_spawn_time < ENEMY_SPAWN_TIME_MIN then
			self.enemy_spawn_time = ENEMY_SPAWN_TIME_MIN
		end
	end

	if self.player then
		self.player:update(dt)
	end

	for i=#self.enemies, 1, -1 do
		self.enemies[i]:update(dt)
		if self.enemies[i]:is_dead() then
			table.remove(self.enemies, i)
		end
	end

	self:check_collisions()
end

function Game:check_collisions()
	for key, enemy in pairs(self.enemies) do
		for key2, bullet in pairs(self.player.bullets) do
			if bullet.body:check(enemy.body) then
				-- kill the enemy --
				enemy.dead = true
				bullet.dead = true
				break
			end
		end
		
		if self.player.body:check(enemy.body) then
			-- kill the player
			love.load()
		end
	end
	
end

function Game:draw()
	if self.player then
		self.player:draw()
	end

	for i, enemy in pairs(self.enemies) do
		enemy:draw()
	end
end

function Game:get_player()
	return self.player
end

function Game:spawn_enemy()
	local Enemy = EnemyList[love.math.random(#EnemyList)]
	
	local spawn_pos = Vec2()

	if love.math.random() < 0.5 then
		spawn_pos.x = love.math.random() * love.graphics.getWidth()
		if love.math.random() < 0.5 then
			spawn_pos.y = -40
		else
			spawn_pos.y = 40 + love.graphics.getHeight()
		end
	else
		spawn_pos.y = love.math.random() * love.graphics.getHeight()
		if love.math.random() < 0.5 then
			spawn_pos.x = -40
		else
			spawn_pos.x = 40 + love.graphics.getWidth()
		end
	end

	local enemy = Enemy(spawn_pos)
	enemy.parent = self
	table.insert(self.enemies, enemy)
end

return Game
