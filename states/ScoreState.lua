--[[
    SCORE STATE CLASS
    CS50G Project 1
    Fifty bird (Flappy Bird remake)
    Author: Maxime Blanc
    https://github.com/salty-max
--]]

-- extends BaseState class
ScoreState = Class{__includes = BaseState}

function ScoreState:init()
    -- initialize medals table
    self.medals = {
        ['bronze'] = {
            ['label'] = 'Bronze',
            ['sprite'] = love.graphics.newImage('resources/images/bronze.png'),
            ['threshold'] = 5
        },
        ['silver'] = {
            ['label'] = 'Silver',
            ['sprite'] = love.graphics.newImage('resources/images/silver.png'),
            ['threshold'] = 10
        },
        ['gold'] = {
            ['label'] = 'Gold',
            ['sprite'] = love.graphics.newImage('resources/images/gold.png'),
            ['threshold'] = 20
        }
    }

    -- initialize reached medal to nil
    self.reachedMedal = nil
    -- medal default y 
    self.medalY = -20
    -- medal animation timer
    self.animationTimer = 0
end

--[[
    When entering score state, expect to receive the score
    from the play state.
]]
function ScoreState:enter(params)
    self.score = params.score

    -- check if the reached score
    -- is greater or equal to any medal threshold
    -- if this medal's threshold is reached, set it as the reached medal
    if self.score >= self.medals['bronze'].threshold and self.score < self.medals['silver'].threshold then
        self.reachedMedal = self.medals['bronze']
    elseif self.score >= self.medals['silver'].threshold and self.score < self.medals['gold'].threshold then
        self.reachedMedal = self.medals['silver']
    elseif self.score >= self.medals['gold'].threshold then
        self.reachedMedal = self.medals['gold']
    end
end

function ScoreState:update(dt)
    -- medal animation
    self.animationTimer = self.animationTimer + dt

    -- move medal up and down every half second
    if self.animationTimer > 0.5 then
        if self.medalY == -20 then
            self.medalY = -30
        else
            self.medalY = -20
        end

        -- reset the timer so it actually animates
        self.animationTimer = 0
    end

    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:draw()
    -- render the score and the awarded medal
    love.graphics.setFont(mediumFont)
    
    -- if a score threshold has been reached, display the corresponding medal sprite
    if self.reachedMedal then
        love.graphics.draw(
            self.reachedMedal.sprite,
            VIRTUAL_WIDTH / 2 - self.reachedMedal.sprite:getWidth() / 2,
            self.medalY -- animated y
        )
        -- display congrats text
        love.graphics.printf('You have reached the ' .. self.reachedMedal.label ..' medal!', 0, 160, VIRTUAL_WIDTH, 'center')
    else
        -- display boo text
        love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')
    end
    
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, self.reachedMedal and 180 or 100, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to Play Again!', 0, self.reachedMedal and 220 or 160, VIRTUAL_WIDTH, 'center')
end