local Vec2 = class("Vec2")

function is_vec2(obj)
	return type(obj) == "table" and type(obj.isInstanceOf) == "function" and obj:isInstanceOf(Vec2)
end

function Vec2:init(x, y)
	if x and y then
		assert(type(x) == "number", "x value has to be a number.")
		assert(type(y) == "number", "y value has to be a number.")

		self.x = x
		self.y = y
	elseif type(x) == "number" then
		self.x = x
		self.y = y
	elseif is_vec2(x) then
		self.x = x.x
		self.y = x.y
	elseif type(x) == "table" then
		-- {x, y} or {x=x, y=y} --
		assert(type(x.x) == "number" or type(x[1]) == "number", "x value has to be a number.")
		assert(type(x.y) == "number" or type(x[2]) == "number", "y value has to be a number.")
		
		if x.x then
			self.x = x.x
		elseif x[1] then
			self.x = x[1]
		end

		if x.y then
			self.y = x.y
		elseif x[2] then
			self.y = x[2]
		end
	
	else
		self.x = 0
		self.y = 0
	end
end

function Vec2.clone(vec)
	assert(is_vec2(vec), "Please call :clone().")

	return Vec2(vec:unpack())
end

function Vec2.angle_between(a, b)
	assert(is_vec2(a) and is_vec2(b), "Can only find the angle between two vectors.")
	
	local amag = a:mag()
	local bmag = b:mag()
	assert(amag > 0 and bmag > 0, "There is no angle between zero vectors.")

	return math.acos(a:dot(b) / (amag * bmag))
end

function Vec2.rotate(vec, theta)
	-- returns a new vector rotated by theta --
	assert(is_vec2(vec), "Only vectors can be rotated!")
	assert(type(theta) == "number", "The angle must be a number!")

	return Vec2(vec.x * math.cos(theta) - vec.y * math.sin(theta), vec.x * math.sin(theta) + vec.y * math.cos(theta))
end

function Vec2.dot(a, b)
	assert(is_vec2(a) and is_vec2(b), "Dot product can only be between two vectors.")

	return a.x * b.x + a.y * b.y
end

function Vec2.normalize(vec)
	assert(is_vec2(vec), "Please use Vec2:normalize()")

	local length2 = vec:mag2()

	if length2 == 0 or length2 == 1 then
		return
	end

	local length = math.sqrt(length2)

	vec.x = vec.x / length
	vec.y = vec.y / length
end

function Vec2.normalized(vec)
	assert(is_vec2(vec), "Please use Vec2:normalized()")

	local length = vec:mag()

	if length == 0 then
		return Vec2()
	end

	return vec / length
end

function Vec2.mag(a)
	assert(is_vec2(a), "Please use Vec2:mag().")

	return math.sqrt(a.x * a.x + a.y * a.y)
end

function Vec2.mag2(a)
	assert(is_vec2(a), "Please use Vec2:mag2().")

	return a.x * a.x + a.y * a.y
end

function Vec2.unpack(vec)
	assert(is_vec2(vec), "Please use Vec2:unpack().")

	return vec.x, vec.y
end

function Vec2.__add(a, b)
	assert(is_vec2(a) and is_vec2(b), "Vector addition is only between two vectors.")

	return Vec2(a.x + b.x, a.y + b.y)
end

function Vec2.__sub(a, b)
	assert(is_vec2(a) and is_vec2(b), "Vector subtraction is only between two vectors.")

	return Vec2(a.x - b.x, a.y - b.y)
end

function Vec2.__mul(a, b)
	local vec, scalar

	if is_vec2(a) and type(b) == "number" then
		vec = a
		scalar = b
	elseif type(a) == "number" and is_vec2(b) then
		scalar = a
		vec = b
	else
		error("Invalid types for vector-scalar multiplication. Only a number and a Vec2 allowed!")
	end

	return Vec2(vec.x * scalar, vec.y * scalar)
end

function Vec2.__div(a, b)
	local vec, scalar = a, b
	
	assert(is_vec2(vec), "Invalid types for vector-scalar division. Only a number and a Vec2 allowed!")
	assert(type(scalar) == "number", "Invalid types for vector-scalar division. Only a number and a Vec2 allowed!")
	assert(scalar ~= 0, "Don't divide vectors by zero >:(")

	return Vec2(vec.x / scalar, vec.y / scalar)
end

function Vec2.__tostring(vec)
	assert(is_vec2(vec), "Why are you doing this?")

	return string.format("(%.2f, %.2f)", vec.x, vec.y)
end

return Vec2
