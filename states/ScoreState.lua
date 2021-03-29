--[[
    SCORE STATE CLASS
    CS50G Project 1
    Fifty bird (Flappy Bird remake)
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

-- extends BaseState class
ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:draw()
    -- render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof, you lost!', 0, 64, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to play again!', 0, 160, VIRTUAL_WIDTH, 'center')
end