local A =
{
    {   1.502,  0,      0.0514, 0.0408, 0.1013},
    {   0.0261, 0,      1.1516, 0.0320, 0.09943},
    {   0.0342, 2.532,  0.0355, 0.2933, 0.2194},
    {   0.034,  0,      0.0684, 0.3470, 0.03396},
}

-- 预处理矩阵
for i=1,5 do
    A[2][i] = A[2][i] + A[3][i]
end
for i=1,5 do
    A[3][i] = A[3][i] - A[2][i]
end

-- Jacobi
local x = {0,0,0,0}
local function Jacobi(xi)
    for i=1,50 do
        local px = {}
        for j=1,4 do
            px[j] = A[j][5];
            for k = 1,4 do
                if k ~= j then
                    px[j] = px[j] - A[j][k]*xi[k];
                end
            end
            px[j] = px[j] / A[j][j]
        end
        xi = px
        local function rd(x) return math.floor(x*1000000+0.5)/1000000 end
        print("iter "..i.." : "..rd(xi[1]).." "..rd(xi[2]).." "..rd(xi[3]).." "..rd(xi[4]))
    end
end

Jacobi(x)

-- Gauss
x = {0,0,0,0}
local function Gauss(xi)
    for i=1,50 do
        for j=1,4 do
            xi[j] = A[j][5];
            for k = 1,4 do
                if k ~= j then
                    xi[j] = xi[j] - A[j][k]*xi[k];
                end
            end
            xi[j] = xi[j] / A[j][j]
        end
        local function rd(x) return math.floor(x*1000000+0.5)/1000000 end
        print("iter "..i.." : "..rd(xi[1]).." "..rd(xi[2]).." "..rd(xi[3]).." "..rd(xi[4]))
    end
end

Gauss(x)