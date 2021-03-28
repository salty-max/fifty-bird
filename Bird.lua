--[[
  CS50G Project 1
  Fifty bird (Flappy Bird remake)
  Author: Maxime Blanc
  https://github.com/salty-max
  BIRD CLASS
--]]
Bird = Class {}

local GRAVITY = 20
local JUMP_VELOCITY = 5

function Bird:init()
    self.image = love.graphics.newImage('resources/images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:update(dt)
    -- apply gravity each frame to the bird
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -JUMP_VELOCITY
    end

    -- apply current velocity to y position
    self.y = self.y + self.dy
end

function Bird:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
