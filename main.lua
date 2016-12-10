require "slam"
vector = require "hump.vector"
Timer = require "hump.timer"

require "helpers"
require "game"

scale = 4 -- how many screen pixels are the length of one game pixel?
tilesize = 16 -- what is the length of a tile in game pixels?

function love.load()
    boringLoad() -- see helpers.lua

    setScale(4)

    love.graphics.setFont(fonts.m5x7[16])

    room = loadRoom("levels/level1.txt")

    objects = {}

    table.insert(objects, {what = "plant", x = 6, y = 3, r = 0})
    table.insert(objects, {what = "plant", x = 7, y = 3, r = 0})
    table.insert(objects, {what = "shelf", x = 8, y = 2, r = 1})
    table.insert(objects, {what = "shelf", x = 9, y = 2, r = 1})
    table.insert(objects, {what = "shelf", x = 10, y = 2, r = 1})

    holding = nil
end

function love.update(dt)
    Timer.update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        -- why did we need this again?
        -- love.window.setFullscreen(false)
        -- love.timer.sleep(0.1)
        love.event.quit()
    elseif key == "1" then
        setScale(1)
    elseif key == "2" then
        setScale(2)
    elseif key == "3" then
        setScale(4)
    elseif key == "4" then
        setScale(8)
    elseif key == "5" then
        setScale(16)
    end
end

function love.mousepressed(x, y, button, touch)
    tx = math.floor(x/scale/tilesize)
    ty = math.floor(y/scale/tilesize)

    if button == 1 then
        what = occupied(tx, ty)
        if what then
            holding = what
        end
    end
    if button == 2 then
        if holding then
            what.r = (what.r + 1) % 4
        else
            what = occupied(tx, ty)
            if what then
                what.r = (what.r + 1) % 4
            end
        end
    end
end

function love.mousereleased(x, y, button, touch)
    if button == 1 then
        if holding then
            holding.x = round(holding.x)
            holding.y = round(holding.y)
            holding = nil
        end
    end
end

function love.mousemoved(x, y, dx, dy, touch)
    if holding then
        holding.x = x/scale/tilesize-0.5
        holding.y = y/scale/tilesize-0.5
    end
end

function love.draw()
    love.graphics.scale(scale, scale)

    drawRoom(room)

    for i = 1, #objects do
        drawObject(objects[i])
    end

    drawDebug()

    --love.graphics.print("Text!", 100, 0)
end
