local stream = require 'stream'

local cf = {}

local cf_next = function(list, st)
    nextval = math.tointeger(1/st.rem // 1)
    st.rem = 1/st.rem - nextval
    return nextval
end

cf.approx_num = function(f, i)
    i = i or #f.contents

    if i == 0 then
        return 1
    elseif i == 1 then
        return f[i]
    else
        return f[i] * cf.approx_num(f, i - 1) + cf.approx_num(f, i - 2)
    end
end

cf.approx_den = function(f, i)
    i = i or #f.contents

    if i == 0 then
        return 0
    elseif i == 1 then
        return 1
    else
        return f[i] * cf.approx_den(f, i - 1) + cf.approx_den(f, i - 2)
    end
end

cf.fraction = function(f, i)
    return ('%d/%d'):format(cf.approx_num(f, i), cf.approx_den(f, i))
end

cf.approximate = function(f, i)
    i = i or 1
    if i > #f.contents then return 0 end
    return f.contents[i] + (i == #f.contents and 0 or 1 / cf.approximate(f, i + 1))
end

cf.list = function(f)
    local str = ('[%d'):format(f.contents[1])
    if #f.contents > 1 then
        for i=2,#f.contents do
            str = ('%s%s%s'):format(str, (i == 2 and ':' or ','), f.contents[i])
        end
    end
    return ('%s]'):format(str)
end

cf.pi = stream:new(
    math.tointeger(math.pi // 1),
    cf_next,
    nil,
    { rem = math.pi - math.tointeger(math.pi // 1) }
)

cf.phi = stream:new(
    1,
    cf_next,
    nil,
    { rem = 0.6180339887498948482045868343656381177203091798057628621354486227 }
)

cf.root2 = stream:new(
    math.tointeger(math.sqrt(2) // 1),
    cf_next,
    nil,
    { rem = math.sqrt(2) - math.tointeger(math.sqrt(2) // 1) }
)

return cf
