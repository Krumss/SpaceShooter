Button = Class()

local DISABLE = "disabled"
local NORMAL = "normal"
local HIGHLIGHT = "highlight"

local function color(r, g, b, alpha)
    return {r / 255, g / 255, b / 255, alpha / 255 or 1.0}
end

local function gray(level, alpha)
    return {level / 255, level / 255, level / 255, alpha / 255 or 1.0}
end

function Button:init(x, y, width, height, text)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.state = NORMAL

    self.cursorOn = false
    self.hit = false

    --button state / colours
    self.disabledColor = gray(128, 255)
    self.normalColor = color(168, 64, 61, 255)
    self.highlightedColor = color(255, 97, 92, 255)

    self.textColor = color(255, 255, 255, 255)

end

function Button:update(dt) 
    mX = love.mouse.getX() / WINDOW_WIDTH * VIRTUAL_WIDTH
    mY = love.mouse.getY() / WINDOW_HEIGHT * VIRTUAL_HEIGHT

    if mX > self.x and mX < self.x + self.width then
        if mY > self.y and mY < self.y + self.height then
            if self.cursorOn == false then
                gSounds['hovermenu']:play()
            end
            
            self.cursorOn = true
        else
            self.cursorOn = false
        end
    else
        self.cursorOn = false
    end

    if self.state ~= DISABLE then
        if self.cursorOn == true then
            self.state = HIGHLIGHT
        else
            self.state = NORMAL
        end
    end

    if love.mouse.isDown(1) and self.cursorOn == true and self.state ~= DISABLE then
        self.hit = true
        gSounds['hovermenu']:play()
    else 
        self.hit = false
    end

end

function Button:render()
    if self.state == HIGHLIGHT then
        love.graphics.setColor(self.highlightedColor)
    elseif self.state == NORMAL then
        love.graphics.setColor(self.normalColor)
    elseif self.state == DISABLE then
        love.graphics.setColor(self.disabledColor)
    else

    end

    love.graphics.rectangle(
        'fill', 
        self.x, 
        self.y,
        self.width, 
        self.height
    )

    love.graphics.setColor(self.textColor)
    buttonFont = love.graphics.newFont(72)
    buttonFont:getHeight()
    love.graphics.setFont(buttonFont)
    love.graphics.printf(
        self.text, 
        self.x, 
        self.y + self.height / 2 - (buttonFont:getHeight(self.text) / 2), 
        self.width, 
        'center'
    )

end

function Button:setButtonColor(normalColor, hightlightColor)  
    self.normal = color(normalColor[0], normalColor[1], normalColor[2], normalColor[3])
    self.highlighted = color(hightlightColor[0], hightlightColor[1], hightlightColor[2], hightlightColor[3])
end
