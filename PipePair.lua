--[[
  CS50G Project 1
  Fifty bird (Flappy Bird remake)
  Author: Maxime Blanc
  https://github.com/salty-max
  PIPE PAIR CLASS
--]]
PipePair = Class {}

-- size of the gap between pipes
GAP_HEIGHT = 90

function PipePair:init(y)
    -- initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32
    -- y value is for the topmost pipe only; gap is a vertical shift of the second
    self.y = y
    -- instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + GAP_HEIGHT)
    }
    -- whether this pipe pair is ready to be removed from the scene
    self.remove = false
end

function PipePair:update(dt)
    -- flag the pipe to be removed from the scene if it's beyond the left edge of the screen
    -- else move it right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:draw()
    for k, pipe in pairs(self.pipes) do
        pipe:draw()
    end
end
