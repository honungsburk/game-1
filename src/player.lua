local sheet = Sprites.playerSheet
local grid = anim8.newGrid(16, 16, sheet:getWidth(), sheet:getHeight())

local animations = {}
-- First parameter: columns, second parameter: which row
-- seconds per frame
local walking_seconds_per_frame = 0.1

animations.walking = {}
animations.walking.down = anim8.newAnimation(grid('1-4', 1), walking_seconds_per_frame)
animations.walking.down_left = anim8.newAnimation(grid('1-4', 2), walking_seconds_per_frame)
animations.walking.left = anim8.newAnimation(grid('1-4', 3), walking_seconds_per_frame)
animations.walking.up_left = anim8.newAnimation(grid('1-4', 4), walking_seconds_per_frame)
animations.walking.up = anim8.newAnimation(grid('1-4', 5), walking_seconds_per_frame)
animations.walking.up_right = anim8.newAnimation(grid('1-4', 6), walking_seconds_per_frame)
animations.walking.right = anim8.newAnimation(grid('1-4', 7), walking_seconds_per_frame)
animations.walking.down_right = anim8.newAnimation(grid('1-4', 8), walking_seconds_per_frame)

animations.idle = {}
animations.idle.down = anim8.newAnimation(grid(1, 1), 1)
animations.idle.down_left = anim8.newAnimation(grid(1, 2), 1)
animations.idle.left = anim8.newAnimation(grid(1, 3), 1)
animations.idle.up_left = anim8.newAnimation(grid(1, 4), 1)
animations.idle.up = anim8.newAnimation(grid(1, 5), 1)
animations.idle.up_right = anim8.newAnimation(grid(1, 6), 1)
animations.idle.right = anim8.newAnimation(grid(1, 7), 1)
animations.idle.down_right = anim8.newAnimation(grid(1, 8), 1)

function pickDirection(animations, angle)
  -- 0 radians is right
  -- pi/2 radians is down
  -- pi radians is left
  -- 3pi/2 radians is up
  if angle < math.pi / 8 then
    return animations.right
  elseif angle < 3 * math.pi / 8 then
    return animations.down_right
  elseif angle < 5 * math.pi / 8 then
    return animations.down
  elseif angle < 7 * math.pi / 8 then
    return animations.down_left
  elseif angle < 9 * math.pi / 8 then
    return animations.left
  elseif angle < 11 * math.pi / 8 then
    return animations.up_left
  elseif angle < 13 * math.pi / 8 then
    return animations.up
  elseif angle < 15 * math.pi / 8 then
    return animations.up_right
  else
    return animations.right
  end
end

Player = {}

function Player:new(params)
  local o = {}
  -- o will look up any missing method in Player
  -- https://www.lua.org/pil/16.1.html
  setmetatable(o, self)
  self.__index = self

  -- Create a dynamic player body in world
  o.body = world:newRectangleCollider(
    360,
    100,
    params.scale * 16,
    params.scale * 16,
    { collision_class = 'Player' })
  o.body:setFixedRotation(true)
  -- o.body:setMass(10)
  -- o.body:setLinearDamping(10)
  -- o.body:setAngularDamping(10)

  o.speed = params.speed or 240
  o.rotation = 0
  o.direction = 0
  o.animation = animations.idle.down
  o.body:setPosition(params.x or 0, params.y or 0)
  o.body:setMass(1)
  o.scale = params.scale or 1

  return o
end

function Player:draw()
  if player.body then
    -- Draw the player
    player.animation:draw(
      sheet,
      self.body:getX(),
      self.body:getY(),
      nil,
      self.scale,
      self.scale,
      16 / 2,
      16 / 2)
  end
end

function Player:update(dt, input)
  local delta = vector(0, 0)

  -- Velocity
  local x, y = input:get('move')
  if (x ~= 0 or y ~= 0) then
    print("x:" .. x .. " y:" .. y)
  end


  if input:down('left') then
    delta.x = -1
  elseif input:down('right') then
    delta.x = 1
  end

  if input:down('up') then
    delta.y = -1
  elseif input:down('down') then
    delta.y = 1
  end

  delta:normalizeInplace()


  local velocity = delta * player.speed * dt
  local vx, vy = velocity:unpack()

  self.body:setLinearVelocity(vx, vy)

  -- Animation
  local animation = animations.idle

  if (velocity:len() > 0) then
    local right = vector(1, 0)
    -- Can return negactive values when the angle is greater than pi/2
    local direction = velocity:angleTo(right)
    if direction < 0 then
      direction = direction + 2 * math.pi
    end

    self.direction = direction
    animation = animations.walking
  else

  end


  self.animation = pickDirection(animation, self.direction)

  -- Get the player's current velocity
  -- local vx, vy = self.body:getLinearVelocity()

  -- -- Set the player's velocity
  -- local newVx, newVy = 0, 0

  -- if love.keyboard.isDown("w") then
  --   self.body:setLinearVelocity(self.speed, 0)
  --   self.direction = "right"
  -- elseif love.keyboard.isDown("left") then
  --   self.body:setLinearVelocity(-self.speed, 0)
  --   self.direction = "left"
  -- else
  --   self.body:setLinearVelocity(0, vy)
  -- end

  -- -- Set the player's rotation
  -- if self.direction == "right" then
  --   self.rotation = math.atan2(vy, vx)
  -- else
  --   self.rotation = math.atan2(vy, vx) + math.pi
  -- end
  player.animation:update(dt)
end
