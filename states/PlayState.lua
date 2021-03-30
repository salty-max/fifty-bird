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
PIPE_SPAWN_COOLDOWN = math.random(2, 4)

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
    self.paused = false
end

function PlayState:update(dt)
    if not self.paused then
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
            PIPE_SPAWN_COOLDOWN = math.random(2, 4)
            GAP_HEIGHT = math.random(80, 100)
        end

        self.bird:update(dt)

        for k, pair in pairs(self.pipePairs) do
            -- score a point if the pipe has gone past the bird
            -- ignore the pair it has alreaby been scored
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end

            -- update position of pair
            pair:update(dt)

            -- check to see if bird collided with a pipe
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end

            -- end the game if the bird touch the ground
            if self.bird.y > VIRTUAL_HEIGHT - 15 then
                sounds['explosion']:play()
                sounds['hurt']:play()

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

    if love.keyboard.wasPressed('p') then
        self.paused = true
        -- send all game props to the pause state
        -- to store them while the game is not running
        gStateMachine:change('pause', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            timer = self.pipeSpawnTimer,
            score = self.score,
            lastY = self.lastY
        })
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

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter(params)
    -- if we're coming from death, restart scrolling
    scrolling = true
    self.paused = false
    
    -- fetch back stored values and reassign them
    if params then
        self.bird = params.bird
        self.pipePairs = params.pipePairs
        self.pipeSpawnTimer = params.timer
        self.score = params.score
        self.lastY = params.lastY
    end
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end