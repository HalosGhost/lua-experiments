local s = {}

local smt = {
    __call = function(init, generator, capacity)
        return s:new(init, generator, capacity)
    end
}

function s:cache_to(index)
    assert(type(self.contents) == 'table')
    assert(#self.contents > 0)

    if not index then return end
    if type(index) ~= 'number' then
        error('index was non-null, and non-numeric')
    end

    assert(index > #self.contents)

    assert(type(self.gen) == 'function')

    for i=#self.contents+1,index do
        self.contents[i] = self.gen(self.contents, self.state)
    end
end

function s:new(init, generator, capacity, state)
    local stream = {}

    stream.gen = generator
    stream.contents = { init }
    stream.state = state

    local mt = {
        __index = function(t, k)
            if type(k) == 'number' then
                if not t.contents[k] then
                    t:cache_to(k)
                end
                
                return t.contents[k]
            else
                return s[k]
            end
        end
    }

    setmetatable(stream, mt)

    stream:cache_to(capacity)

    return stream
end

return setmetatable(s, smt)
