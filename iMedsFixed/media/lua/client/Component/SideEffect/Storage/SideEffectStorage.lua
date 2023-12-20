SideEffectStorage = {}

---@return SideEffectStorage
function SideEffectStorage:new()
    ---@class SideEffectStorage
    local public = {}
    local private = {}

    ---@type SideEffect[]
    private.sideEffects = ZCore:getContainer():getByTag('imeds.side_effect.entity')

    ---@return SideEffect[]
    function public:findAll()
        return private.sideEffects
    end

    ---@param alias string
    ---@return SideEffect|nil
    function public:getByAlias(alias)
        for _, sideEffect in pairs(private.sideEffects) do
            if sideEffect:getAlias() == alias then
                return sideEffect
            end
        end

        return nil
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'SideEffectStorage'

    return public
end

return SideEffectStorage