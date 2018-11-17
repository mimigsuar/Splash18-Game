local Trail = class("Trail")

Trail.disabled = false

function Trail:init(image)
	--self.disabled = disable
	self.ps = love.graphics.newParticleSystem(image)
	self.ps:setParticleLifetime(0.25)
	self.ps:setEmissionRate(10)
	self.ps:setColors(1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 0.0)
	self.ps:start()
end

function Trail:update(pos, dt)
	if Trail.disabled then
		return
	end

	self.ps:update(dt)
	self.ps:setPosition(pos.x, pos.y)
end

function Trail:draw(offsetx, offsety)
	if Trail.disabled then
		return
	end
	
	love.graphics.draw(self.ps, offsetx, offsety)
end

return Trail
