--[[
  CS50G Project 1
  Fifty bird (Flappy Bird remake)
  Author: Maxime Blanc
  https://github.com/salty-max
  PIPE CLASS
--]]
Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage('resources/images/pipe.png')

PIPE_SPEED = 60

PIPE_WIDTH = 70
PIPE_HEIGHT = 288

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
end

function Pipe:draw()
    love.graphics.draw(
        PIPE_IMAGE,
        self.x,
        self.y + PIPE_HEIGHT,
        0, -- rotation
        1, -- X scale
        self.orientation == 'top' and -1 or 1 -- Y scale
    )
end
