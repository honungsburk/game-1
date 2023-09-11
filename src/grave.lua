local sheet = Sprites.graveSheet
local spriteSize = 16
local grid = anim8.newGrid(spriteSize, spriteSize, sheet:getWidth(), sheet:getHeight())


local animations = {}
animations.idle = anim8.newAnimation(grid(1, 1), 1)

Grave = {}

function Grave:new(params)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  -- Create a dynamic player body in world
  o.x = params.x or 0
  o.y = params.y or 0
  o.width = params.scale * 16
  o.height = params.scale * 16

  o.rotation = 0
  o.scale = params.scale or 1
  o.animation = animations.idle

  o.spawnTimer = 0
  o.maxSpawnTime = 3

  return o
end

function Grave:draw()
  -- Draw the player
  self.animation:draw(
    sheet,
    self.x,
    self.y,
    nil,
    self.scale,
    self.scale,
    spriteSize / 2,
    spriteSize / 2)
end

function Grave:update(dt)
  if self.spawnTimer > 0 then
    self.spawnTimer = self.spawnTimer - dt
  end

  self.animation:update(dt)
end

function Grave:canSpawn(player)
  local x, y = player:getPosition()
  local distance = math.sqrt((x - self.x) ^ 2 + (y - self.y) ^ 2)
  return distance < self.scale * spriteSize / 2 and self.spawnTimer <= 0
end

function Grave:spawn(options)
  local randomX = self.x + math.random(100) - 50
  local randomY = self.y + math.random(100) - 50
  self.spawnTimer = self.maxSpawnTime
  return Skeleton:new({ x = randomX, y = randomY, scale = options.scale or self.scale })
end
