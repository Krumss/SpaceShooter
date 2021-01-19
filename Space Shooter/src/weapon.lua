Weapon = Class()

weaponType = {
    ['beam'] = {
        type = 'beam',
        speed = -0.1
    }, 
    ['missile'] = {
        type = 'missile',
        speed = -0.1
    }
}

function Weapon:init(weaponInfo, x, y, speed)
    self.id = 'weapon'
    self.type = weaponInfo.type

    self.x = x
    self.y = y
    self.dy = speed
    self.width = gTextures[weaponInfo.type..'weapon']:getWidth()
    self.height = gTextures[weaponInfo.type..'weapon']:getHeight()
    self.inPlay = true

end

function Weapon:update(dt)
    self.y = self.y + self.dy

end

function Weapon:render()
    love.graphics.draw(gTextures[self.type..'weapon'], self.x, self.y, 0, 1, 1)

end