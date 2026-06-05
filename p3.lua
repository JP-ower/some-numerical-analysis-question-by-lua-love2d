local ix = {0.5,0.8};
local function fx(x)
    return x*x*x - 6*x*x + 11*x - 6;
end
local function f1x(x)
    return 3*x*x - 12*x + 11;
end
for _,x in ipairs(ix) do
    print("-- x="..x.." --")
    local rst = {x}
    x = x + 0.1*math.random()
    table.insert(rst,x)
    while true do
        local xb = rst[#rst-1]
        x = x - fx(x)*(x-xb)/(fx(x)-fx(xb))
        table.insert(rst,x)
        if #rst >= 2 and math.abs(rst[#rst-1]-rst[#rst])<10^-4 then
            break
        end
    end
    for _,r in ipairs(rst) do
        print("ord=".._.."\tx="..r)
    end
end