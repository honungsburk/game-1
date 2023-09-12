-- Direction functions

Movement = {}

-- Idle
Movement.idle = function(entityPos)
  return vector(0, 0)
end

-- Move up
Movement.up = function(playerPos)
  return vector(0, 1)
end

-- Move down
Movement.down = function(playerPos)
  return vector(0, -1)
end

-- Move left
Movement.left = function(playerPos)
  return vector(-1, 0)
end

-- Move right
Movement.right = function(playerPos)
  return vector(1, 0)
end

-- Move towards a point
Movement.towordsPoint = function(pointPos)
  return function(entityPos)
    return (pointPos - entityPos):normalizeInplace()
  end
end


-- Junctions gives an entity a new movement function when stepped onto

Junction = {}

function Junction:new(params)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.x = params.x or 0
  o.y = params.y or 0
  o.width = params.width or 16
  o.height = params.height or 16
  o.movement = params.movement or Movement.idle
  return o
end

function Junction:intersectsWith(entity)
  local entityX, entityY = entity:getPosition()
  return entityX > self.x and entityX < self.x + self.width and entityY > self.y and entityY < self.y + self.height
end
