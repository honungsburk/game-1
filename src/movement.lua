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
