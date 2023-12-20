BloodGroupStorage = {}

---@return BloodGroupStorage
function BloodGroupStorage:new()
    ---@class BloodGroupStorage
    local public = {}
    local private = {}

    ---@type BloodGroup[]
    private.bloodGroups = ZCore:getContainer():getByTag('imeds.blood.entity.group')

    ---@return BloodGroup|nil
    function public:getRandomBloodGroup()
        --  O+	    A+	    B+	    AB+	    O−	    A−	    B−	    AB−
        --  37.4%	35.7%	8.5%	3.4%	6.6%	6.3%	1.5%	0.6%

        local groupChance = ZombRand(1, 100)
        local rhesusFactorChance = ZombRand(1, 100)
        local groupId

        if groupChance > 0 and groupChance <= 44 then
            if rhesusFactorChance > 85 then
                groupId = BloodGroup.ON
            else
                groupId = BloodGroup.OP
            end
        elseif groupChance > 44 and groupChance <= 86 then
            if rhesusFactorChance > 85 then
                groupId = BloodGroup.AN
            else
                groupId = BloodGroup.AP
            end
        elseif groupChance > 86 and groupChance <= 96 then
            if rhesusFactorChance > 85 then
                groupId = BloodGroup.BN
            else
                groupId = BloodGroup.BP
            end
        elseif groupChance > 96 then
            if rhesusFactorChance > 85 then
                groupId = BloodGroup.ABN
            else
                groupId = BloodGroup.ABP
            end
        end

        return self:getById(groupId)
    end

    ---@param id number
    ---@return BloodGroup|nil
    function public:getById(id)
        for _, group in pairs(private.bloodGroups) do
            if group:getId() == id then
                return group
            end
        end

        return nil
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'BloodGroupStorage'

    return public
end

return BloodGroupStorage