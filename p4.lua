local function sh(x) return (math.exp(x) - math.exp(-x))/2 end
local function ch(x) return (math.exp(x) + math.exp(-x))/2 end
local HEA,l,h,xi = 0.0015,200,250,3500
local function f(x,y)
    return y + HEA*sh(y) - x - HEA*sh(x) - l/xi
end
local function g(x,y)
    return ch(y)+HEA*sh(y*y)/2 - ch(x) - HEA*sh(x*x)/2 - h/xi
end

local function dfpdx(x,y) return -1-HEA*ch(x) end
local function dfpdy(x,y) return 1+HEA*ch(y) end
local function dgpdx(x,y) return -sh(x)-HEA*ch(x)*sh(x) end
local function dgpdy(x,y) return sh(y)+HEA*ch(y)*sh(y) end

local x,y = 1,1.5
local x1,y1 = 1.0192225753183 , 1.0762285187054
for i=1,50 do
    print("Attempt "..i.." with ("..x.." , "..y..") :")
    local A,B,C = dfpdx(x,y),dfpdy(x,y),-f(x,y)
    local D,E,F = dgpdx(x,y),dgpdy(x,y),-g(x,y)
    x = x + (C*E-B*F)/(A*E-B*D)
    y = y + (C*D-A*F)/(B*D-A*E)
    print("-> ("..x.." , "..y..") value: "..f(x,y).." "..g(x,y))
    if (x-x1)^2+(y-y1)^2 < 10^(-8) then
        print("Result: ("..x.." , "..y..")")
        break
    end
end