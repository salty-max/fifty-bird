--[[
  PAUSE STATE CLASS
  CS50G Project 1
  Fifty bird (Flappy Bird remake)
  Author: Maxime Blanc
  https://github.com/salty-max
--]]

-- extends BaseState class
PauseState = Class{__includes = BaseState}

function PauseState:init()
  self.pauseIcon = love.graphics.newImage('resources/images/dio.png')
end

-- pause the music and store game props
function PauseState:enter(params)
  sounds['pause']:play()
  sounds['music']:pause()
  self.bird = params.bird
  self.pipePairs = params.pipePairs
  self.timer = params.timer
  self.score = params.score
  self.lastY = params.lastY
end

-- resume music on exit
function PauseState:exit()
  sounds['pause']:play()
  sounds['music']:play()
end

function PauseState:update(dt)
  if love.keyboard.wasPressed('p') then
    -- send back game props to the play state
    gStateMachine:change('play', {
      bird = self.bird,
      pipePairs = self.pipePairs,
      timer = self.timer,
      score = self.score,
      lastY = self.lastY
    })
  end
end

function PauseState:draw()
  -- display last state of the game
  for k, pair in pairs(self.pipePairs) do
      pair:draw()
  end

  self.bird:draw()

  love.graphics.setFont(flappyFont)
  love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

  -- apply opacified black overlay
  love.graphics.setColor(0, 0, 0, 80/255)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  -- reset color to white
  love.graphics.setColor(1, 1, 1, 1)
  -- display icon
  love.graphics.draw(self.pauseIcon, VIRTUAL_WIDTH / 2 - self.pauseIcon:getWidth() / 2, 40)
  
  -- display text
  love.graphics.setFont(flappyFont)
  love.graphics.printf('Za Warudo!', 0, 180, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Press P to resume', 0, 220, VIRTUAL_WIDTH, 'center')
end