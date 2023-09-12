local sheet = Sprites.skeletonSwordmanSheet
local spriteSizeX = 40
local spriteSizeY = 33
local grid = anim8.newGrid(spriteSizeX, spriteSizeY, sheet:getWidth(), sheet:getHeight())


local animations = {}
animations.idle = anim8.newAnimation(grid(1, 1), 1)

Skeleton = {}



function Skeleton:new(params)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  -- Create a dynamic player body in world
  o.x = params.x or 0
  o.y = params.y or 0
  o.width = params.scale * spriteSizeX
  o.height = params.scale * spriteSizeY
  o.rotation = 0
  o.scale = params.scale or 1
  o.animation = animations.idle
  o.speed = params.speed or 100
  o.movement = params.movement or Movement.idle

  return o
end

function Skeleton:setMovement(movement)
  self.movement = movement
end

function Skeleton:draw()
  -- Draw the player
  self.animation:draw(
    sheet,
    self.x,
    self.y,
    nil,
    self.scale,
    self.scale,
    spriteSizeX / 2,
    spriteSizeY / 2)
end

function Skeleton:update(dt)
  self.animation:update(dt)

  local direction = self.movement(vector(self.x, self.y)):normalizeInplace()
  self.x = self.x + direction.x * dt * self.speed
  self.y = self.y + direction.y * dt * self.speed
end
