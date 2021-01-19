Item = Class()

itemType = {
    [0] = {
        ['type'] = 'shield',
        ['inPlay'] = true
    }, 
    [1] = {
        ['type'] = 'powerup',
        ['inPlay'] = true
    }
}

function Item:init(x, y, itemInfo)

    self.id = 'item'
    self.type = itemInfo['type']

    self.x = x
    self.y = y

    self.dx = math.random(-100, 100)
    self.dy = math.random(0, 600)

    self.width = gTextures[self.type..'item']:getWidth() * 0.3
    self.height = gTextures[self.type..'item']:getHeight() * 0.3

    self.inPlay = itemInfo['inPlay']
end

function Item:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- allow ball to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        
    end

    if self.x >= VIRTUAL_WIDTH - gTextures[self.type..'item']:getWidth() * 0.3 then
        self.x = VIRTUAL_WIDTH - gTextures[self.type..'item']:getWidth() * 0.3
        self.dx = -self.dx
        
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        
    end
end

function Item:render()
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.draw(gTextures[self.type..'item'], self.x, self.y, 0, 0.3, 0.3)
    love.graphics.setColor(1, 1, 1, 1)
end