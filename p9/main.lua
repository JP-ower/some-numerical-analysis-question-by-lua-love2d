---@diagnostic disable: duplicate-set-field
local xs = {
    [0] = {0,0}
}
local ksi = {0.2,0.5,0.707,0.9}
local s = ""
local rd = function(x)
    return math.floor(x*1000000-0.5)/1000000
end
local function _2add(...)
    local args = {...}
    local a,b = 0,0
    for _,v in ipairs(args) do
        a = a + v[1]
        b = b + v[2]
    end
    return {a,b}
end
local function _2mul(A,a)
    return {A[1]*a,A[2]*a}
end

for j=3,3 do
    local h = 0.25
    local xin = 0
    
    for i=1,100 do
        xin = xin + h
        if xin > 60 then
            xin = 60
        end
        local x1,x2 = xs[i-1][1],xs[i-1][2]
        local k1 = {x2 , -100*x1-20*ksi[j]*x2+1}
        local k2 = {x2+h*k1[2]/2 , 1-100*(x1+h*k1[1]/2)-20*ksi[j]*(x2+h*k1[2]/2)}
        local k3 = {x2+h*k2[2]/2 , 1-100*(x1+h*k2[1]/2)-20*ksi[j]*(x2+h*k2[2]/2)}
        local k4 = {x2+h*k3[2]/2 , 1-100*(x1+h*k3[1])-20*ksi[j]*(x2+h*k3[2])}
        xs[i] = _2add(xs[i-1] , _2mul(_2add(k1,k2,k2,k3,k3,k4),h/6))
        if xin == 60 then
            s = s..rd(100*xs[i][1])..","
            break
        end
    end
end
local point = {}

local left,right,step = 0,5,1
local up,down = 2,0
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
local pl = {}
local fn = function() end
function love.load()
    for i=0,10000 do
        if xs[i] == nil then break end
        local p = sc({i*0.25,xs[i][1]*100})
        table.insert(pl,p[1])
        table.insert(pl,p[2])
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
        love.graphics.print(tostring(var),gapx-45,ty,0,1,1)
    end
end

function love.draw()
    
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",0,0,nx,ny)

    draw_grid(left,right,5,up,down,10)


    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",gapx,gapy,lw,ny-2*gapy)
    love.graphics.rectangle("fill",gapx,ny-gapy,nx-2*gapx,lw)
    love.graphics.polygon("fill",gapx-2*lw,gapy,gapx+3*lw,gapy,gapx,gapy-7*lw)
    love.graphics.polygon("fill",nx-gapx,ny-gapy-2*lw,nx-gapx,ny-gapy+3*lw,nx-gapx+7*lw,ny-gapy)
    love.graphics.setLineWidth(2)
    for i=1,#ps,2 do
        love.graphics.circle("fill",ps[i],ps[i+1],5)
    end
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(2)
    love.graphics.line(pl)
end