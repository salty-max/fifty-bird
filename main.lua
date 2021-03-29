--[[
    MAIN PROGRAM
    CS50G Project 1
    Fifty bird (Flappy Bird remake)
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

--[[
    Library to set virtual resolution
    -- https://github.com/Ulydev/push
--]]
push = require 'lib/push'

--[[
    Library to implement a class system in lua
    -- https://github.com/vrld/hump/blob/master/class.lua
--]]
Class = require 'lib/class'

require 'Bird'
require 'Pipe'
-- class representing pair of pipes together
require 'PipePair'

-- all code related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images loaded into memory
local background = love.graphics.newImage('resources/images/background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('resources/images/ground.png')
local groundScroll = 0

-- parallax speed constants
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which background should loop back to X0
local BACKGROUND_LOOPING_POINT = 413

-- scrolling variable to pause the game when the bird collides with a pipe
local scrolling = true

function love.load()
    -- init nearest neighbour filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    -- seed random
    math.randomseed(os.time())

    -- initialize fonts
    smallFont = love.graphics.newFont('resources/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('resources/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('resources/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('resources/fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- init virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    -- scroll our background and ground, looping back to 0 after a certain amount
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- update the state machine, which defers to the right state
    gStateMachine:update(dt)

    -- reset keysPressed table each frame so
    -- it only stores keys pressed on the current frame
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    -- keep track of each key pressed
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    -- Return whether a key has been pressed
    return love.keyboard.keysPressed[key]
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    -- draw state machine between background and foreground, which defers
    -- render logic to the current active state
    gStateMachine:draw()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
