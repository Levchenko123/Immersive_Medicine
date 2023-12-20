BloodBagCreator = {}

---@return BloodBagCreator
function BloodBagCreator:new()
    ---@class BloodBagCreator
    local public = {}

    function public:createFull()
        local fullBloodBag = InventoryItemFactory.CreateItem(FullBloodBag.fullType)

        fullBloodBag:getModData().blood = {
            group = Survivor:getBlood():getGroup():getId(),
            volume = 500,
            maxVolume = 500,
            donor = {
                isInfected = Survivor:isInfected(),
                poisonLevel = Survivor:getPoisonLevel(),
                drunkennessLevel = Survivor:getDrunkenness(),
            },
        }

        return fullBloodBag
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'BloodBagCreator'

    return public
end

return BloodBagCreator