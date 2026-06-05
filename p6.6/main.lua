---@diagnostic disable: duplicate-set-field

-- 数据点 (x, y 交替排列)
local point = {
    261, 0.653,
    332, 0.796,
    335, 0.703,
    365, 0.724,
    378, 0.841,
}

-- 求解三对角矩阵方程 rsq * x = rfq
local function sv(dimension, rsq, rfq)
    -- 前向消元
    for i = 1, dimension - 1 do
        for j = i + 1, dimension do
            local ro = rsq[j][i] / rsq[i][i]
            for k = 1, dimension do
                rsq[j][k] = rsq[j][k] - ro * rsq[i][k]
            end
            rfq[j] = rfq[j] - ro * rfq[i]
        end
    end

    -- 打印矩阵（调试用）
    for i = 1, dimension do
        local s = ""
        for j = 1, dimension do
            s = s .. rsq[i][j] .. "\t\t"
        end
        print(s)
    end

    -- 回代求解
    local solx = {}
    for i = 1, dimension do
        if i > 1 then
            solx[dimension - i + 1] = rfq[dimension - i + 1]
            for j = 1, i - 1 do
                solx[dimension - i + 1] = solx[dimension - i + 1] - solx[dimension - j + 1] * rsq[dimension - i + 1][dimension - j + 1]
            end
            solx[dimension - i + 1] = solx[dimension - i + 1] / rsq[dimension - i + 1][dimension - i + 1]
        else
            solx[dimension] = rfq[dimension] / rsq[dimension][dimension]
        end
    end
    return solx
end

-- 计算步长 h
local h = {}
for i = 1, 4 do
    h[i] = point[2 * i + 1] - point[2 * i - 1]
end

-- 构建系数矩阵
local rsq = {
    {2*(h[1]+h[2]),  h[2],  0},
    {h[2],  2*(h[2]+h[3]),  h[3]},
    {0,     h[3],   2*(h[3]+h[4])}
}

local rfq = {}
for i = 1, 3 do
    rfq[i] = 6 * ((point[2 * i + 3] - point[2 * i + 1]) / h[i + 1] - (point[2 * i + 1] - point[2 * i - 1]) / h[i])
end

-- 求解二阶导数 M
local M = sv(3, rsq, rfq)
M[0], M[4] = 0, 0 -- 自然边界条件

-- 计算样条系数 S
local S = {}
for i = 0, 3 do
    S[i] = {}
    S[i] = point[2 * i + 2]
    S[i] = (point[2 * i + 4] - point[2 * i + 2]) / h[i + 1] - h[i + 1] * (2 * M[i] + M[i + 1]) / 6
    S[i] = M[i] / 2
    S[i] = (M[i + 1] - M[i]) / (6 * h[i + 1])
end

-- 样条插值函数
local fn = function(x)
    local left_idx, right_idx = 1, 5
    -- 边界检查
    if x <= point[2 * left_idx - 1] or x >= point[2 * right_idx - 1] then
        return nil
    end
    
    -- 寻找 x 所在的区间
    while left_idx < right_idx and point[2 * left_idx - 1] < x do 
        left_idx = left_idx + 1 
    end
    
    local xo = point[2 * left_idx - 3]
    left_idx = left_idx - 2
    
    -- 三次多项式求值
    local dx = x - xo
    return S[left_idx] + S[left_idx] * dx + S[left_idx] * dx ^ 2 + S[left_idx] * dx ^ 3
end

-- 绘图相关变量
local draw_point = {}
local left, right, step = 250, 390, 1
local up, down = 3, 0
local nx, ny = love.graphics.getWidth(), love.graphics.getHeight()
local lw = 3
local gapx, gapy = 0.1 * nx, 0.1 * ny

-- 坐标转换函数
local function sc(x)
    local sx,sy = (x[1]-left)/(right-left),(x[2]-down)/(up-down)
    return {
        gapx+sx*(nx-2*gapx),
        gapy+(1-sy)*(ny-2*gapy)
    }
end

local ps = {}

function love.load()
    -- 生成插值点
    for i = left, right, step do
        local y = fn(i)
        if y ~= nil then
            table.insert(draw_point, {i, y})
        end
    end
    
    -- 转换为屏幕坐标
    for i = 1, #draw_point do
        local sp = sc(draw_point[i])
        table.insert(ps, sp[1])
        table.insert(ps, sp[2])
    end
end

-- 绘制网格和坐标轴标签
local function draw_grid(l, r, sx, u, d, sy)
    love.graphics.setLineWidth(2)
    
    -- X 轴网格
    for i = 0, sx do
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
        local tx = gapx + (i / sx) * (nx - 2 * gapx)
        love.graphics.line(tx, gapy, tx, ny - gapy)
        
        love.graphics.setColor(0, 0, 0, 1)
        local var = l + (r - l) * (i / sx)
        love.graphics.print(tostring(math.floor(var * 100) / 100), tx, ny - gapy + 15, 0, 1, 1)
    end
    
    -- Y 轴网格
    for i = 0, sy do
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
        local ty = gapy + (1 - i / sy) * (ny - 2 * gapy)
        love.graphics.line(gapx, ty, nx - gapx, ty)
        
        love.graphics.setColor(0, 0, 0, 1)
        local var = d + (u - d) * (i / sy)
        love.graphics.print(tostring(math.floor(var * 100) / 100), gapx - 40, ty, 0, 1, 1)
    end
end

function love.draw()
    -- 背景
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, nx, ny)

    -- 绘制网格 (修正了参数顺序：left, right, x分格数, up, down, y分格数)
    draw_grid(left, right, 7, up, down, 6)

    -- 绘制坐标轴
    love.graphics.setColor(0, 0, 0)
    -- Y 轴
    love.graphics.rectangle("fill", gapx, gapy, lw, ny - 2 * gapy)
    -- X 轴
    love.graphics.rectangle("fill", gapx, ny - gapy, nx - 2 * gapx, lw)
    -- Y 轴箭头
    love.graphics.polygon("fill", gapx - 2 * lw, gapy, gapx + 3 * lw, gapy, gapx, gapy - 7 * lw)
    -- X 轴箭头
    love.graphics.polygon("fill", nx - gapx, ny - gapy - 2 * lw, nx - gapx, ny - gapy + 3 * lw, nx - gapx + 7 * lw, ny - gapy)
    
    -- 绘制样条曲线
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(2)
    love.graphics.line(ps)
end