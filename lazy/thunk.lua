local t = {}

local tmt = {
    __call = function(fn, args)
        return t:new(fn, args)
    end
}

function t:new(fn, args)
    local thunk = {
        fn = fn,
        args = args
    }

    local mt = {
        __call = function(th)
            if not th.value then
                th:evaluate()
            end

            return th.value
        end,
        __index = t
    }

    return setmetatable(thunk, mt)
end

function t:evaluate()
    self.value = self.fn(table.unpack(self.args))
    return self.value
end

function t:is_resolved()
    return self.value and true or false
end

return setmetatable(t, tmt)
