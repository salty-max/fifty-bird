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
    -- load bird sprite from disk and assign its width and height
    self.image = love.graphics.newImage('resources/images/bird.png')
    self.width = BIRD_WIDTH
    self.height = BIRD_HEIGHT

    -- position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Y velocity; gravity
    self.dy = 0
end

function Bird:update(dt)
    -- apply gravity each frame to the bird
    self.dy = self.dy + GRAVITY * dt

    -- apply anti-gravity by setting dy to a negative value
    if love.keyboard.wasPressed('space') then
        self.dy = -JUMP_VELOCITY
    end

    -- apply current velocity to y position
    self.y = self.y + self.dy
end

function Bird:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
