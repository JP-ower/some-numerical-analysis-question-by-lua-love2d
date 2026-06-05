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

for j=1,4 do
    local h = 1
    local xin = 0
    
    for i=1,100 do
        xin = xin + h
        if xin > 3 then
            xin = 3
        end
        local x1,x2 = xs[i-1][1],xs[i-1][2]
        local k1 = {x2 , -100*x1-20*ksi[j]*x2+1}
        local k2 = {x2+h*k1[2]/2 , 1-100*(x1+h*k1[1]/2)-20*ksi[j]*(x2+h*k1[2]/2)}
        local k3 = {x2+h*k2[2]/2 , 1-100*(x1+h*k2[1]/2)-20*ksi[j]*(x2+h*k2[2]/2)}
        local k4 = {x2+h*k3[2]/2 , 1-100*(x1+h*k3[1])-20*ksi[j]*(x2+h*k3[2])}
        xs[i] = _2add(xs[i-1] , _2mul(_2add(k1,k2,k2,k3,k3,k4),h/6))
        if xin == 3 then
            
            s = s..rd(100*xs[i][1])..","
            break
        end
    end
end
print(s)