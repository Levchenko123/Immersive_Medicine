Container = {}

---@return Container
function Container:new()
    ---@class Container
    local public = {}
    local private = {}

    ---@type table<string, Module>
    private.services = {}
    ---@type table<string, table<string, Module>>
    private.taggedServices = {}

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Container'

    ---@param module table
    ---@param alias string
    ---@param arguments table
    function public:register(module, alias, arguments, tag)
        if private.services[alias] == nil then
            local service = require 'Component/DependencyInjection/Module'

            private.services[alias] = service:new(module:new(unpack(arguments)))

            if tag ~= nil then
                if private.taggedServices[tag] == nil then
                    private.taggedServices[tag] = {}
                end

                private.taggedServices[tag][alias] = private.services[alias].instance
            end
        end
    end

    ---@param alias string
    ---@return table|nil
    function public:get(alias)
        if private.services[alias] ~= nil then
            return private.services[alias].instance
        end

        return nil
    end

    ---@param tag string
    ---@return table|nil
    function public:getByTag(tag)
        if private.taggedServices[tag] ~= nil then
            return private.taggedServices[tag]
        end

        return nil
    end

    return public
end

return Container