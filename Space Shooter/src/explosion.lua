Explosion = Class()

function Explosion:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    local c = love.graphics.newCanvas(10, 10)
    love.graphics.setCanvas(c)
    love.graphics.circle("fill", 10 / 2, 10 / 2, 30)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setCanvas()

    self.flame = love.graphics.newParticleSystem(c, 1000)
    self.flame:setColors(230 / 255, 80 / 255, 59 / 255, 1.0)
    self.flame:setParticleLifetime(0.5, 1) -- (min, max)
	self.flame:setSizeVariation(1)
    self.flame:setLinearAcceleration(-self.width / 2, -self.height / 2, self.width / 2, self.height / 2) -- (minX, minY, maxX, maxY)
    self.flame:setEmissionArea('normal', 20, 20, 6.28, true)
end

function Explosion:update(dt)
    self.flame:update(dt)
end

function Explosion:render()
    love.graphics.draw(self.flame, self.x + self.width / 2, self.y + self.height / 2)
end
