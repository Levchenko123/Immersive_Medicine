DrugGroup = {
    Analgesic = {
        alias = 'Analgesic',
        name = getText('UI_DrugGroup_Morphine_Name'),
        description = getText('UI_DrugGroup_Morphine_Description'),
    },
}

---@param group string
---@return DrugGroup
function DrugGroup:new(group)
    ---@class DrugGroup
    local public = {}
    local private = {}

    ---@type string
    private.group = group

    ---@return string
    function public:getAlias()
        return DrugGroup[private.group].alias
    end

    ---@return string
    function public:getName()
        return DrugGroup[private.group].name
    end

    ---@return string
    function public:getDescription()
        return DrugGroup[private.group].description
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'DrugGroup'

    return public
end

return DrugGroup