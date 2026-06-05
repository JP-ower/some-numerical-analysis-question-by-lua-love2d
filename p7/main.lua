---@diagnostic disable: duplicate-set-field

local point = {
    1,  10838,
    2,  19123,
    3,  28447.08,
    3.5,25946.35,
    4,  25859.64,
    4.5,25895.24,
    5,  25136.25,
    5.5,25346.2,
    6,  24831.84,
    7,  27896.14,
    8,  29234.71,
    9,  30859.45,
    10, 31741.14,
    11, 32045.36,
    12, 32896.63,
    13, 33748.65,
    14, 33956.47,
    15, 34029.52,
    16, 34212.66,
    17, 34512.21,
    18, 34895.63,
    19, 34984.63,
    20, 35213.34,
    21, 35489.47,
    22, 35669.21,
    23, 35675.14,
    24, 35702.36,
    25, 35711.92,
    26, 35714.12,
    27, 35701.25,
    28, 35641.84,
    29, 35148.15,
    30, 34214.36,
    31, 33021.15,
    32, 30541.65,
    33, 27584.31
}

local left,right,step = 0,35,1
local up,down = 36000,10000
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
    for i=1,36 do
        local sp = sc({point[i*2-1],point[i*2]})
        table.insert(ps,sp[1])
        table.insert(ps,sp[2])
    end

    -- 最小二乘法
    local dimension = 6
    local sqs = {}
    for i=0,2*dimension do
        sqs[i] = 0
        for j=1,#point do
            if j%2==1 then
                sqs[i] = sqs[i] + point[j] ^ i
            end
        end
    end
    local fqs = {}
    for i=0,dimension do
        fqs[i] = 0
        for j=1,#point do
            if j%2==1 then
                fqs[i] = fqs[i] + point[j+1] * (point[j] ^ i)
            end
        end
    end
    local rsq,rfq = {},{}
    for i=1,dimension do
        rsq[i] = {}
        for j=1,dimension do
            rsq[i][j] = sqs[i+j-2]
        end
    end
    for i=1,dimension do
        rfq[i] = fqs[i-1]
    end

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
    fn = function(x)
        local ans = 0;
        for i=1,dimension do
            ans = ans + solx[i] * x^(i-1)
        end
        return ans
    end

    for i=0,35,0.5 do
        local plf = sc({i,fn(i)})
        print("i="..i.." fn(i)="..fn(i))
        table.insert(pl,plf[1])
        table.insert(pl,plf[2])
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

    draw_grid(left,right,7,up,down,13)


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