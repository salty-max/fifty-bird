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

function love.load()
    -- init nearest neighbour filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    -- init virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    -- scroll our background and ground, looping back to 0 after a certain amount
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    bird:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:draw()

    push:finish()
end
