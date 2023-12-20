MoodleStorage = {}

---@return MoodleStorage
function MoodleStorage:new()
    ---@class MoodleStorage
    local public = {}
    local private = {}

    ---@type Moodle[]
    private.moodles = ZCore:getContainer():getByTag('imeds.moodle.entity')

    ---@return Moodle[]
    function public:findAll()
        return private.moodles
    end

    ---@param alias string
    ---@return Moodle|nil
    function public:getByAlias(alias)
        for _, sideEffect in pairs(private.moodles) do
            if sideEffect:getAlias() == alias then
                return sideEffect
            end
        end

        return nil
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'MoodleStorage'

    return public
end

return MoodleStorage