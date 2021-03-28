--[[
  CS50G Project 1
  Fifty bird (Flappy Bird remake)
  Author: Maxime Blanc
  https://github.com/salty-max
  PIPE CLASS
--]]
Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage('resources/images/pipe.png')
local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 40)
    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:draw()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end
