Menu = Class()

function Menu:init(x, y)
    self.buttonWidth = VIRTUAL_WIDTH / 3
    self.buttonHeight = 128
    self.margin = 42
    
    self.x = x --(VIRTUAL_WIDTH - self.buttonWidth) / 2
    self.y = y --(VIRTUAL_HEIGHT - self.totalHeight) / 2

    self.buttons = {
        ['play'] = Button(self.x, self.y, self.buttonWidth, self.buttonHeight, 'PLAY'), 
        ['exit'] = Button(self.x, self.y + self.buttonHeight + self.margin, self.buttonWidth, self.buttonHeight, 'EXIT')

    }
    self.totalHeight = (self.buttonHeight + self.margin) * #self.buttons
end

function Menu:update(dt)
    for key, button in pairs(self.buttons) do
        button:update(dt)
    end

    if (self.buttons['play'].hit == true) then
        gSounds['startmusic']:stop()
        gStateMachine:change('play')
    end

    if self.buttons['exit'].hit == true then
        love.event.quit()
    end

end

function Menu:render()
    love.graphics.circle('fill', love.mouse.getX() * VIRTUAL_WIDTH / WINDOW_WIDTH, love.mouse.getY() / WINDOW_WIDTH * VIRTUAL_WIDTH, 10)

    for key, button in pairs(self.buttons) do
        button:render()
    end
end

