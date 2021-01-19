Enemy = Class()

NORMAL = 'normal'
EXPLODING = 'exploding'
DEAD = 'dead'

enemyTypes = {
    [0] = {
        ['color'] = 'blue', 

        ['scaleX'] = 0.5, 
        ['scaleY'] = 0.5, 

        ['dy'] = 3, 
        ['state'] = NORMAL, 
        ['shootTimer'] = 3, 
        ['explosionTimer'] = 0.7, 
        ['shootInterval'] = 3
    }, 
    [1] = {
        ['color'] = 'red', 

        ['scaleX'] = 0.5, 
        ['scaleY'] = 0.5, 

        ['dy'] = 6, 
        ['state'] = NORMAL, 
        ['shootTimer'] = 2, 
        ['explosionTimer'] = 0.7, 
        ['shootInterval'] = 1
    }
}


function Enemy:init(enemyInfo)

    self.id = 'enemy'
    self.color = enemyInfo['color']

    self.x = math.random(20, VIRTUAL_WIDTH - 300)
    self.y = -300

    self.scaleX = enemyInfo['scaleX']
    self.scaleY = enemyInfo['scaleY']

    self.width = gTextures[enemyInfo['color']..'enemy']:getWidth() * self.scaleX
    self.height = gTextures[enemyInfo['color']..'enemy']:getHeight() * self.scaleY
    self.dy = enemyInfo['dy']
    self.state = enemyInfo['state']

    self.shootTimer = enemyInfo['shootTimer']
    self.explosionTimer = enemyInfo['explosionTimer']

    self.shootInterval = enemyInfo['shootInterval']

    local c = love.graphics.newCanvas(10, 10)
    love.graphics.setCanvas(c)
    love.graphics.circle("fill", 10 / 2, 10 / 2, 10)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setCanvas()

    self.flame = love.graphics.newParticleSystem(c, 5000)
    self.flame:setColors(255 / 255, 255 / 255, 255 / 255, 1.0, 
                        255 / 255, 255 / 255, 255 / 255, 1.0,
                        242 / 255, 226 / 255, 5 / 255, 1.0, 
                        242 / 255, 183 / 255, 5 / 255, 1.0, 
                        242 / 255, 159 / 255, 5 / 255, 0.9, 
                        242 / 255, 116 / 255, 5 / 255, 0.9, 
                        255 / 255, 68 / 255, 5 / 255, 0.9)
    self.flame:setParticleLifetime(0.2, 0.5) -- (min, max)
    self.flame:setSizes(0.5, 0.8)
    self.flame:setSpeed(100, 200)
    self.flame:setLinearAcceleration(-self.width * 1.2, -self.height * 1.2, self.width * 1.2, self.height * 1.2) -- (minX, minY, maxX, maxY)
    self.flame:setEmissionArea('normal', 10, 10, 0, true)

    self.laser = {}
    
end

function Enemy:hit(object)
    if(self.x + 20) + (self.width - 40) >= object.x and self.x + 20 <= object.x + object.width then
        if self.y < object.y + object.height - 50 and self.y + self.height - 60 > object.y - 50 then
            return true    
        end
    end
    
    return false
end

function Enemy:update(dt)
    self.y = self.y + self.dy
    if self.state == EXPLODING then
        self.explosionTimer = self.explosionTimer - dt
    end
    self.flame:update(dt)
end

function Enemy:render()
    if self.state ~= EXPLODING then
        love.graphics.draw(gTextures[self.color..'enemy'], self.x, self.y, 0, self.scaleX, self.scaleY)
    elseif self.explosionTimer >= 0.55 then
        love.graphics.draw(gTextures['enemyExplosion'], self.x, self.y, 0, self.scaleX, self.scaleY)
    end
    
    for key, laser in pairs(self.laser) do
        laser:render()
    end
end

function Enemy:explosion()
    self.flame:emit(5000) 
    gSounds['explosion']:play()
end

function Enemy:renderFlame()
    love.graphics.draw(self.flame, self.x + self.width / 2, self.y + self.height / 2)
end

function Enemy:shoot()
    if self.shootTimer < 0 and self.state ~= EXPLODING then
        gSounds['paddle-hit']:play()
        table.insert(self.laser, Weapon(weaponType['beam'] , self.x + self.width * 259 / 377, self.y + self.height * 248 / 284, WEAPON_SPEED))
        self.shootTimer = self.shootInterval
    end
end