--[[
  PLAY STATE CLASS
  CS50G Project 1
  Fifty bird (Flappy Bird remake)
  Author: Maxime Blanc
  https://github.com/salty-max
--]]

-- extends BaseState class
PlayState = Class{__includes = BaseState}

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

PIPE_SPEED = 60
PIPE_SPAWN_COOLDOWN = 2

PIPE_WIDTH = 70
PIPE_HEIGHT = 288


function PlayState:init()
    self.bird = Bird()
    -- pipes storage table
    self.pipePairs = {}
    -- delay between pipes spawns
    self.pipeSpawnTimer = 0

    -- keep track of the score
    self.score = 0

    -- init the last recorded Y value for gap placement
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.pipeSpawnTimer = self.pipeSpawnTimer + dt

    if self.pipeSpawnTimer > 2 then
        -- modify the last Y coordinate so pipe gaps aren't too far away,
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length from the bottom
        local y = math.max(-PIPE_HEIGHT + 10,
                    math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))
        self.lastY = y
        -- add pipe to pipes storage
        table.insert(self.pipePairs, PipePair(y))
        -- reset timer to avoid spawning pipes every frame
        self.pipeSpawnTimer = 0
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird
        -- ignore the pair it has alreaby been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end

        -- update position of pair
        pair:update(dt)

        -- check to see if bird collided with a pipe
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end

        -- end the game if the bird touch the ground
        if self.bird.y > VIRTUAL_HEIGHT - 15 then
            gStateMachine:change('score', {
                score = self.score
            })
        end
    end

    -- remove any flagged pipes
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end
end

function PlayState:draw()
    -- draw pipes before ground so it looks like to come from it
    for k, pair in pairs(self.pipePairs) do
        pair:draw()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8 ,8)

    self.bird:draw()
end