if arg[#arg] == "vsc_debug" then require("lldebugger").start() end

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
  Sprites.playerSheet = love.graphics.newImage('sprites/player-sheet.png')
  Sprites.playerSheet:setFilter("nearest", "nearest")

  -- Create a world with 0 gravity in both x and y direction
  world = wf.newWorld(0, 0, false)
  world:setQueryDebugDrawing(true)

  world:addCollisionClass('Player' --[[, { ignores = { 'Platform' } }]])

  -- Load files
  require('src/player')
  require('src/input')

  -- create input
  input = createInput()

  -- Create player
  player = Player:new({ x = 360, y = 100, speed = 200000, scale = Sprite_Scale })
end

--[[ The main game loop
  dt: delta time, the time between frames

  Tips:
   - runs every frame
  ]]
function love.update(dt)
  input:update()
  world:update(dt)
  player:update(dt, input)
end

--[[
  Tips:
  - runs every frame
  ]]
function love.draw()
  player:draw()
  world:draw()
  -- cam:attach()
  -- cam:detach()
end
