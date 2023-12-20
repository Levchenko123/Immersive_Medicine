HandlerDecorator = {}

---@return HandlerDecorator
function HandlerDecorator:new(handler)
    ---@class HandlerDecorator
    local public = {}
    local private = {}

    private.handler = handler

    function public:getInstance()
        return private.handler
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'HandlerDecorator'

    return public
end

return HandlerDecorator