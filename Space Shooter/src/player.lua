require 'src/weapon'

Player = Class()

NORMAL = 'normal'
PROTECTED = 'protected'
DEAD = 'dead'

weaponPos = {
    ['beam'] = {
        ['x'] = {['0'] = 105/401, ['1'] = 296/401}, 
        ['y'] = {['0'] = 99/276, ['1'] = 99/276}
    },
    ['missile'] = {
        ['x'] = {['0'] = 169/401, ['1'] = 229/401}, 
        ['y'] = {['0'] = 9/276, ['1'] = 9/276}
    },
    ['laser'] = {
        {194/401, 14/276}
    }
}

function Player:init()

    self.id = 'player'
    self.color = 1
    self.image = love.graphics.newImage('graphics/Spaceship_01_RED.png')

    self.maxLife = 100
    self.life = 100
    self.state = NORMAL

    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - 100

    self.scaleX = 0.5
    self.scaleY = 0.5

    self.width = self.image:getWidth() * self.scaleX
    self.height = self.image:getHeight() * self.scaleY

    self.dx = 0
    self.dy = 0

    self.itemTimer = 0

    local c = love.graphics.newCanvas(10, 10)
    love.graphics.setCanvas(c)
    love.graphics.circle("fill", 10, 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setCanvas()
    
    self.flame = love.graphics.newParticleSystem(c, 1000)
    self.flame:setColors(17/255, 20/255, 140/255, 1.0, 
                        35/255, 40/255, 2235/255, 1.0, 
                        39/255, 127/255, 242/255, 0.8, 
                        34/255, 183/255, 242/255, 0.5, 
                        42/255, 242/255, 242/255, 0.5)
	self.flame:setParticleLifetime(0.5, 1) -- (min, max)
	self.flame:setSizes(0.01, 0.5)
    self.flame:setLinearAcceleration(-20, 0, 20, 120) -- (minX, minY, maxX, maxY)
    self.flame:setEmissionArea('normal', 1, 3, 0.1, true)
    
    self.numweapon = {
        ['beam'] = 2,
        ['missile'] = 1
    }

    self.weapon = {
        ['beam'] = {
        }, 
        ['missile'] = {
        }
    }
  
end

function Player:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PLAYER_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PLAYER_SPEED
    else
        self.dx = 0
        --self.flame:setLinearAcceleration(-3, 80, 3, 130)
    end

    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end

    -- keyboard input
    if love.keyboard.isDown('up') then
        self.dy = -PLAYER_SPEED
    elseif love.keyboard.isDown('down') then
        self.dy = PLAYER_SPEED    
    else
        self.dy = 0
    end

    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

    if self.itemTimer > 0 then
        self.itemTimer = self.itemTimer - dt
    else
        self.state = NORMAL
    end
    
    self.flame:update(dt)
    self.flame:emit(500)
end

function Player:hit(object)
    if self.state ~= PROTECTED then
        if(self.x + 20) + (self.width - 40) >= object.x and self.x + 20 <= object.x + object.width then
            if self.y < object.y + object.height - 50 and self.y + self.height - 60 > object.y - 50 then
                if object.id == 'weapon' and object.inPlay == true then
                    self.life = self.life - 15
                elseif object.id == 'enemy' and object.state == NORMAL then
                    self.life = self.life - 20
                elseif object.id == 'item' and object.inPlay == true then
                    if object.type == 'shield' then
                        self.state = PROTECTED
                        self.itemTimer = 3
                    else

                    end

                end
                return true
            end
        end
    else 
        if(self.x - 40) + (self.width + 40) >= object.x and self.x - 40 <= object.x + object.width then
            if self.y - 40 < object.y + object.height  and self.y + self.height + 40 > object.y then
                if object.id == 'item' and object.inPlay == true then
                    if object.type == 'shield' then
                        self.state = PROTECTED
                        self.itemTimer = 3
                    else

                    end

                end
                return true
            end
        end
    end

    return false
end

function Player:render()
    love.graphics.draw(self.flame, self.x + self.width / 2, self.y + self.height - 10)
    love.graphics.draw(gTextures['player'], self.x, self.y, 0, self.scaleX, self.scaleY)

    if self.state == PROTECTED then
        love.graphics.draw(gTextures['shield'], self.x - 40, self.y - 40, 0, (self.width + 80) / gTextures['shield']:getWidth(), (self.width + 80) / gTextures['shield']:getWidth())
    end

    for key, weapon in pairs(self.weapon) do
        for k, weaponpair in pairs(weapon) do
            for j, each in pairs(weaponpair) do
                each:render()
            end
        end
    end

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', self.x + self.width * 1 / 6, self.y + self.height * 1.3, self.width * 2 / 3, 30)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle('fill', self.x + self.width * 1 / 6 + 3, self.y + self.height * 1.3 + 3, (self.width * 2 / 3 - 6) * (self.life / self.maxLife), 24)
    love.graphics.setColor(1, 1, 1, 1)
end

function Player:shoot()
    if love.keyboard.wasPressed('space') then
        gSounds['paddle-hit']:play()
        for key, weapon in pairs(self.weapon) do
            
            weaponpair = {}
            for i = 0, self.numweapon[key] - 1, 1 do
                self.a = tostring(i)
                table.insert(weaponpair, Weapon(weaponType[key], self.x + self.width * weaponPos[key]['x'][tostring(i)], self.y + self.height * weaponPos[key]['y'][tostring(i)], -WEAPON_SPEED))

            end
            table.insert(weapon, weaponpair) 
        end
    end
end