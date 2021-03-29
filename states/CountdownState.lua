--[[
    COUNTDOWN STATE CLASS
    CS50G Project 1
    Fifty bird (Flappy Bird remake)
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

-- extends BaseState class
CountdownState = Class{__includes = BaseState}

-- takes 3/4 quarter of a second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded the countdown time. If it goes down to 0,
    switch to play state
--]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:draw()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end