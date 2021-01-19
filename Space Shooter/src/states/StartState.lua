StartState = Class{__includes = BaseState}


function StartState:init()
    self.menu = Menu(VIRTUAL_WIDTH / 3, VIRTUAL_HEIGHT / 2)
    --gSounds['startmusic']:play()

end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('space') then
        gSounds['startmusic']:stop()
        gStateMachine:change('play')
    end
    self.menu:update(dt)

end

function StartState:render()
    love.graphics.setFont(gFonts['largeghost'])
    love.graphics.printf("Space Shooter", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    self.menu:render()
end



