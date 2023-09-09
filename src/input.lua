-- https://github.com/tesselode/baton
local baton = require '../libraries/baton/baton'


function createInput()
  local input = baton.new {
    controls = {
      left = { 'key:left', 'key:a', 'axis:leftx-', 'button:dpleft' },
      right = { 'key:right', 'key:d', 'axis:leftx+', 'button:dpright' },
      up = { 'key:up', 'key:w', 'axis:lefty-', 'button:dpup' },
      down = { 'key:down', 'key:s', 'axis:lefty+', 'button:dpdown' },
      action = { 'key:e', 'button:a' },
    },
    pairs = {
      move = { 'left', 'right', 'up', 'down' }
    },
    joystick = love.joystick.getJoysticks()[1],
  }

  return input
end
