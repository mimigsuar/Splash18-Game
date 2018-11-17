-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
local function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

local Body = class("Collision")

Body.debug_draw = false

local function is_body(obj)
	return type(obj) == "table" and type(obj.isInstanceOf) == "function" and obj:isInstanceOf(Body)
end

function Body:init(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end

function Body:move(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function Body:resize(w, h)
	self.w = w or self.w
	self.h = h or self.h
end

function Body:check(other)
	return CheckCollision(self.x, self.y, self.w, self.h, other.x, other.y, other.w, other.h)
end

function Body:draw(col)
	if not Body.debug_draw then return end
	love.graphics.setColor(col)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	love.graphics.setColor(1, 1, 1, 1)
end

return Body
