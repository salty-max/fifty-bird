--[[
  CS50G Project 1
  Fifty bird (Flappy Bird remake)
  Author: Maxime Blanc
  https://github.com/salty-max
  MAIN
--]] --
--
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

local bird = Bird()

-- pipes storage table
local pipePairs = {}

-- delay between pipes spawns
local PIPE_SPAWN_COOLDOWN = 2
local pipeSpawnTimer = 0

-- init the last recorded Y value for a gap placement
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- scrolling variable to pause the game when the bird collides with a pipe
local scrolling = true

function love.load()
    -- init nearest neighbour filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    -- seed random
    math.randomseed(os.time())

    -- init virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if scrolling then
        -- scroll our background and ground, looping back to 0 after a certain amount
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        pipeSpawnTimer = pipeSpawnTimer + dt

        if pipeSpawnTimer > 2 then
            -- modify the last Y coordinate so pipe gaps aren't too far away,
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length from the bottom
            local y = math.max(-PIPE_HEIGHT + 10,
                        math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))
            lastY = y
            -- add pipe to pipes storage
            table.insert(pipePairs, PipePair(y))
            -- reset timer to avoid spawning pipes every frame
            pipeSpawnTimer = 0
        end

        bird:update(dt)

        for k, pair in pairs(pipePairs) do
            pair:update(dt)

            -- check to see if bird collided with a pipe
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    -- pause the game to show collision
                    scrolling = false
                end
            end
        end

        -- remove any flagged pipes
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end
    end

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

    -- draw pipes before ground so it looks like to come from it
    for k, pair in pairs(pipePairs) do
        pair:draw()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:draw()

    push:finish()
end
