PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player()
    self.enemy = {Enemy(enemyTypes[0])}
    self.score = 0
    self.timeInterval = 5
    self.level = 1
    self.items = {}

    self.timer = 0
    self.endGame = false

    gSounds['playmusic']:play()
    
end

function PlayState:update(dt)
    --paused
    if self.paused then
        if love.keyboard.wasPressed('p') then
            gSounds['paddle-hit']:play()
            self.paused = false
        else
            return
        end
    elseif love.keyboard.wasPressed('p') then
        gSounds['paddle-hit']:play()
        self.paused = true

        return
    end

    self.timer = self.timer + dt

    --make enemy
    if self.timer > self.timeInterval then
        table.insert(self.enemy, Enemy(enemyTypes[math.random(0, 1)]))
        self.timer = 0
    end

    --enemy updates
    for key, enemy in pairs(self.enemy) do
        --enemy updates
        enemy:update(dt)

        --shoot laser form enemy
        enemy:shoot()
        enemy.shootTimer = enemy.shootTimer - dt

        --enemy die
        if enemy.state == EXPLODING then
            enemy.explosionTimer = enemy.explosionTimer - dt
            if enemy.explosionTimer < 0 then
                enemy.state = DEAD
            end
        end

        if enemy.state == DEAD then
            self.score = self.score + 5
            table.remove(self.enemy, key)
        end
    
        --enemy reach the end
        if enemy.y >=VIRTUAL_HEIGHT - 40 then
            self.endGame = true
        end

    end

    --update enemy laser
    for key, enemy in pairs(self.enemy) do
        for key, laser in pairs(enemy.laser) do
            laser:update(dt)
            if laser.y > VIRTUAL_HEIGHT or laser.inPlay == false then
                table.remove(enemy.laser, key)
            end
        end
    end

    --player updates
    self.player:update(dt)

    --player shoot laser
    self.player:shoot()

    --update player laser
    for key, weapon in pairs(self.player.weapon) do
        for k, weaponpair in pairs(weapon) do
            for j, each in pairs(weaponpair) do
                each:update(dt)
            end
        end
    end

    --update item
    for key, item in pairs(self.items) do
        item:update(dt)
    end

    --collision and hit
    for key, enemy in pairs(self.enemy) do
        --enemy got hit
        for k, weapon in pairs(self.player.weapon) do
            for j, weaponpair in pairs(weapon) do
                for i, each in pairs(weaponpair) do
                    if enemy:hit(each) then
                        enemy.state = EXPLODING
                        enemy:explosion()
                        each.inPlay = false
                        table.remove(weaponpair, i)
                        if (math.random() > 0.7) then
                            table.insert(self.items, Item(enemy.x, enemy.y, itemType[math.random(0, 1)]))
                        end
                    end
                end
                if #weaponpair == 0 then
                    table.remove(weapon, j)
                end
            end
        end

        --player got hit by laser
        for k, laserEnemy in pairs(enemy.laser) do
            if self.player:hit(laserEnemy) then
                laserEnemy.inPlay = false
            end
        end

        --player got hit by enemy
        if self.player:hit(enemy) and enemy.state == NORMAL then
            enemy.state = EXPLODING
            enemy:explosion()
            if (math.random() > 0.7) then
                table.insert(self.items, Item(enemy.x, enemy.y, itemType[0]))
            end
        end

        --player dead
        if self.player.life <= 0 then
            self.player.state = DEAD
            self.endGame = true
        end
    end

    --player hit item
    for key, item in pairs(self.items) do
        if self.player:hit(item) then
            item.inPlay = false
            table.remove(self.items, key)
        end
    end

    --level up
    if self.score > self.level * 15 then
        self.level = self.level + 1
        if self.timeInterval > 1 then
            self.timeInterval = self.timeInterval - math.random(0.3, 1) * 1
        end
        if self.level > 10 then
            self.timeInterval = 0.1
        end
    end

    --end game
    if self.endGame == true then
        gSounds['victory']:play()
        gSounds['playmusic']:stop()
        gStateMachine:change('over', {score = self.score})
    end

    --quit
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end

function PlayState:render()
    self.player:render()
    
    for key, enemy in pairs(self.enemy) do
        enemy:render()
        enemy:renderFlame()
    end

    for key, item in pairs(self.items) do
        item:render()
    end

    love.graphics.draw(gTextures['markboard'], 5, 15, 0, 0.5, 0.4)

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Score: '.. tostring(self.score), 40, 30, 650, 'left')
    love.graphics.printf('Level: '.. tostring(self.level), 40, 90, 650, 'left')

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['medium8bit'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end
