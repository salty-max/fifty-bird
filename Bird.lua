--[[
    BIRD CLASS
    CS50G Project 1
    Fifty bird (Flappy Bird remake)
    Author: Maxime Blanc
    https://github.com/salty-max
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

--[[
    AABB Collision Detection
--]]
function Bird:collides(pipe)
    -- the 2-s are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box of the player
    -- i.e. a little a bit a leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    -- apply gravity each frame to the bird
    self.dy = self.dy + GRAVITY * dt

    -- apply anti-gravity by setting dy to a negative value
    if love.keyboard.wasPressed('space') then
        self.dy = -JUMP_VELOCITY
        sounds['jump']:play()
    end

    -- apply current velocity to y position
    self.y = self.y + self.dy
end

function Bird:draw()
    love.graphics.draw(self.image, self.x, self.y)
    -- Hitbox debug
    --love.graphics.rectangle('line', self.x + 2, self.y + 2, self.width - 4, self.height - 4)
end
