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

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Images loaded into memory
local background = love.graphics.newImage('resources/images/background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('resources/images/ground.png')
local groundScroll = 0

-- Parallax speed constants
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

function love.load()
    -- Init nearest neighbour filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    -- Init virtual resolution
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
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.print(-backgroundScroll)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end
