local ix = {0.5,0.8,1.5,1.8,2.5,2.8};
local function fx(x)
    return x*x*x - 6*x*x + 11*x - 6;
end
local function f1x(x)
    return 3*x*x - 12*x + 11;
end
for _,x in ipairs(ix) do
    print("-- x="..x.." --")
    local rst = {}
    while true do
        table.insert(rst,x)
        x = x - fx(x)/f1x(x)
        if #rst >= 2 and math.abs(rst[#rst-1]-rst[#rst])<10^-4 then
            break
        end
    end
    for _,r in ipairs(rst) do
        print("ord=".._.."\tx="..r)
    end
end