if arg[#arg] == "vsc_debug" then require("lldebugger").start() end

local function loadSheet(name)
  local sheet = love.graphics.newImage('sprites/' .. name .. '.png')
  sheet:setFilter("nearest", "nearest")
  return sheet
end

function love.load()
  -- Set the window title
  love.window.setTitle("Reverse Tower Defense")
  love.window.setMode(800, 600, { resizable = false, vsync = false, minwidth = 400, minheight = 300 })

  -- Set random seed
  -- math.randomseed(os.time())

  -- Libs
  wf = require "libraries/windfield/windfield"
  anim8 = require "libraries/anim8/anim8"
  sti = require "libraries/Simple-Tiled-Implementation/sti"
  cameraFile = require "libraries/hump/camera"
  vector = require "libraries/hump/vector"

  cam = cameraFile()


  -- Sprites
  Sprite_Scale = 4

  Sprites = {}
  Sprites.playerSheet = loadSheet('player-sheet')
  Sprites.skeletonSwordmanSheet = loadSheet('skeleton-swordman')
  Sprites.graveSheet = loadSheet('grave')

  -- Create a world with 0 gravity in both x and y direction
  world = wf.newWorld(0, 0, false)
  world:setQueryDebugDrawing(true)

  world:addCollisionClass('Player' --[[, { ignores = { 'Platform' } }]])

  -- Load files
  require('src/player')
  require('src/input')
  require('src/grave')
  require('src/skeleton')
  require('src/movement')

  -- create input
  input = createInput()

  -- Create player
  player = Player:new({ x = 360, y = 100, speed = 200000, scale = Sprite_Scale })

  -- Create Grave
  grave = Grave:new({ x = 200, y = 200, scale = Sprite_Scale })

  -- Skeletons
  skeletons = {}
end

--[[ The main game loop
  dt: delta time, the time between frames

  Tips:
   - runs every frame
  ]]
function love.update(dt)
  input:update()
  world:update(dt)
  grave:update(dt)
  player:update(dt, input)
  if grave:canSpawn(player) then
    table.insert(skeletons, grave:spawn({ scale = 2, movement = Movement.right }))
  end

  for i, skeleton in ipairs(skeletons) do
    skeleton:update(dt)
  end
end

--[[
  Tips:
  - runs every frame
  ]]
function love.draw()
  cam:attach()
  world:draw()
  grave:draw()
  for i, skeleton in ipairs(skeletons) do
    skeleton:draw()
  end
  player:draw()
  cam:detach()
end
