require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Space Shooter')

    gFonts = {
        ['small'] = love.graphics.newFont(68),
        ['medium8bit'] = love.graphics.newFont('fonts/font.ttf', 96),
        ['large8bit'] = love.graphics.newFont('fonts/font.ttf', 132), 
        ['largeghost'] = love.graphics.newFont('fonts/ghostclangradital.ttf', 150)
    }

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),

        ['player'] = love.graphics.newImage('graphics/Spaceship_01_RED.png'),

        ['beamweapon'] = love.graphics.newImage('graphics/try4_09.png'), 
        ['missileweapon'] = love.graphics.newImage('graphics/missile1.png'),

        ['blueenemy'] = love.graphics.newImage('graphics/Spaceship_02_BLUE.png'),
        ['redenemy'] = love.graphics.newImage('graphics/Spaceship_02_RED.png'),

        ['enemyExplosion'] = love.graphics.newImage('graphics/enemyExplosion.png'),

        ['markboard'] = love.graphics.newImage('graphics/markboard.png'), 

        ['shield'] = love.graphics.newImage('graphics/spr_shield.png'), 

        ['shielditem'] = love.graphics.newImage('graphics/shielditem.png'), 
        ['powerupitem'] = love.graphics.newImage('graphics/powerupitem.png')
    }

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    gSounds = {
        ['explosion'] = love.audio.newSource('sounds/Explosion.mp3', 'static'),
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),

        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),

        ['hovermenu'] = love.audio.newSource('sounds/hovermenu.wav', 'static'),

        ['startmusic'] = love.audio.newSource('sounds/music.wav', 'static'), 
        ['playmusic'] = love.audio.newSource('sounds/Valiant - AShamaluevMusic.mp3', 'static')

    }


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true, 
        fullscreen = false, 
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end, 
        ['play'] = function() return PlayState() end, 
        ['over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h) 
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt) 
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:apply('start')
    -- background should be drawn regardless of state, scaled to fit our
    -- virtual resolution
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
        -- draw at coordinates 0, 0
        0, 0, 
        -- no rotation
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()

    push:apply('end')
end
