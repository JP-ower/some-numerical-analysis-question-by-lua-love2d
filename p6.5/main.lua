---@diagnostic disable: duplicate-set-field

local point = {
    314,    0.734,
    329,    0.738,
    341,    0.747,
    360,    0.755,
    372,    0.768,
}
-- local point = {
--     308,    0.692,
--     320,    0.745,
--     331,    0.778,
--     357,    0.967,
--     365,    0.969,
-- }
-- local point = {
--     261,    0.653,
--     332,    0.796,
--     335,    0.703,
--     365,    0.724,
--     378,    0.841,
-- }
local left,right,step = 310,380,1
local up,down = 0.77,0.73
local mx1,mx2 = 7,4
local function sv(dimension,rsq,rfq)
    -- solve rsq * x = rfq
    for i=1,dimension-1 do
        for j=i+1,dimension do
            local ro = rsq[j][i]/rsq[i][i];
            for k=1,dimension do
                rsq[j][k] = rsq[j][k] - ro * rsq[i][k]
            end
            rfq[j] = rfq[j] - ro * rfq[i]
        end
    end

    for i=1,dimension do
        local s = ""
        for j=1, dimension do
            s = s..rsq[i][j].."\t\t"
        end
        print(s)
    end
    local solx = {}
    for i=1,dimension do
        if i>1 then
            solx[dimension-i+1] = rfq[dimension-i+1]
            for j=1,i-1 do
                solx[dimension-i+1] = solx[dimension-i+1] - solx[dimension-j+1]*rsq[dimension-i+1][dimension-j+1]
            end
            solx[dimension-i+1] = solx[dimension-i+1] / rsq[dimension-i+1][dimension-i+1]
        else
            solx[dimension] = rfq[dimension] / rsq[dimension][dimension]
        end
    end
    return solx
end

local h = {}
for i=1,4 do
    h[i] = point[2*i+1]-point[2*i-1]
end
print("h:")
for i=1,4 do
    print(h[i])
end
local rsq = {
    {2*(h[1]+h[2]),  h[2],  0},
    {h[2],  2*(h[2]+h[3]),  h[3]},
    {0,     h[3],   2*(h[3]+h[4])}
}
local rfq = {}
for i=1,3 do
    rfq[i] = 6*(
        (point[2*i+4]-point[2*i+2])/h[i+1]
        -
        (point[2*i+2]-point[2*i])/h[i]
    )
end
print("rfq:")
for i=1,3 do
    print(rfq[i])
end
local M = sv(3,rsq,rfq)
for i=1,3 do
    print(M[i])
end
M[0],M[4] = 0,0
local S = {}
for i=0,3 do
    S[i] = {}
    S[i][1] = point[2*i+2];
    S[i][2] = (point[2*i+4]-point[2*i+2])/h[i+1] - h[i+1]*(2*M[i]+M[i+1])/6
    S[i][3] = M[i]/2
    S[i][4] = (M[i+1]-M[i])/(6*h[i+1])
end
for i=0,3 do
    local s = ""
    for j=1, 4 do
        s = s..S[i][j].."\t"
    end
    print(s)
end

local fn = function(x)
    local lefte,righte = 1,5
    if x<=point[2*lefte-1] or x >= point[2*righte - 1] then
        return nil
    end
    while point[2*lefte-1] < x do lefte = lefte + 1 end
    local xo = point[2*lefte-3]
    lefte = lefte - 2
    return S[lefte][1] + S[lefte][2]*(x-xo) + S[lefte][3]*(x-xo)^2 + S[lefte][4]*(x-xo)^3
end

local draw_point = {}
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
        if fn(i) ~= nil then
            table.insert(draw_point,{i,fn(i)})
        end
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

    draw_grid(left,right,mx1,up,down,mx2)


    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",gapx,gapy,lw,ny-2*gapy)
    love.graphics.rectangle("fill",gapx,ny-gapy,nx-2*gapx,lw)
    love.graphics.polygon("fill",gapx-2*lw,gapy,gapx+3*lw,gapy,gapx,gapy-7*lw)
    love.graphics.polygon("fill",nx-gapx,ny-gapy-2*lw,nx-gapx,ny-gapy+3*lw,nx-gapx+7*lw,ny-gapy)
    love.graphics.setLineWidth(2)
    love.graphics.line(ps)
end