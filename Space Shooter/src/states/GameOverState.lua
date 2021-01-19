GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large8bit'])
    love.graphics.printf("GameOver\nYour score is "..tostring(self.score), 0, VIRTUAL_HEIGHT / 4 - 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("press enter to continue", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

end
