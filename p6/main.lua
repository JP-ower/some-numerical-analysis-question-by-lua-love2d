---@diagnostic disable: duplicate-set-field

-- local point = {
--     314,    0.734,
--     329,    0.738,
--     341,    0.747,
--     360,    0.755,
--     372,    0.768,
-- }
-- local point = {
--     308,    0.692,
--     331,    0.778,
--     320,    0.745,
--     357,    0.967,
--     365,    0.969,
-- }
local point = {
    261,    0.653,
    332,    0.796,
    335,    0.703,
    365,    0.724,
    378,    0.841,
}
local fn = function(x)
    local ans = 0
    for i=1,5 do
        local p1 = 1
        for j=1,5 do
            if j ~= i then
                p1 = p1 * (x-point[2*j-1])/(point[2*i-1]-point[2*j-1])
            end
        end
        p1 = p1 * point[2*i]
        ans = ans + p1
    end
    return ans
end

local draw_point = {}
local left,right,step = 250,390,1
local up,down = 3,0
local nx,ny = love.graphics.getWidth(),love.graphics.getHeight()
-- 坐标轴
local lw = 3
local gapx,gapy = 0.1*nx,0.1*ny
local function sc(x)
    local sx,sy = (x[1]-left)/(right-left),(x[2]-down)/(up-down)
    return {
        gapx+sx*(nx-2*gapx),
        gapy+(1-sy)*(ny-2*gapy)
    }
end
local ps = {}

function love.load()
    for i=left,right,step do
        table.insert(draw_point,{i,fn(i)})
    end
    for i=1,#draw_point do
        local sp = sc(draw_point[i])
        table.insert(ps,sp[1])
        table.insert(ps,sp[2])
    end
end

local function draw_grid(l,r,sx,u,d,sy)
    love.graphics.setLineWidth(2)
    
    for i=0,sx do
        love.graphics.setColor(0.5,0.5,0.5,1)
        local tx = gapx+(i/sx)*(nx-2*gapx)
        love.graphics.line(tx,gapy,tx,ny-gapy)
        love.graphics.setColor(0,0,0,1)
        local var = l+(r-l)*(i/sx)
        love.graphics.print(tostring(var),tx,ny-gapy+15,0,1,1)
    end
    for i=0,sy do
        love.graphics.setColor(0.5,0.5,0.5,1)
        local ty = gapy+(1-i/sy)*(ny-2*gapy)
        love.graphics.line(gapx,ty,nx-gapx,ty)
        love.graphics.setColor(0,0,0,1)
        local var = d+(u-d)*(i/sy)
        love.graphics.print(tostring(var),gapx-30,ty,0,1,1)
    end
end

function love.draw()
    
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",0,0,nx,ny)

    draw_grid(left,right,7,up,down,6)


    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",gapx,gapy,lw,ny-2*gapy)
    love.graphics.rectangle("fill",gapx,ny-gapy,nx-2*gapx,lw)
    love.graphics.polygon("fill",gapx-2*lw,gapy,gapx+3*lw,gapy,gapx,gapy-7*lw)
    love.graphics.polygon("fill",nx-gapx,ny-gapy-2*lw,nx-gapx,ny-gapy+3*lw,nx-gapx+7*lw,ny-gapy)
    love.graphics.setLineWidth(2)
    love.graphics.line(ps)
end