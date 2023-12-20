PlasmaBag = {
    ABN = {
        alias = 'PlasmaBagABN',
        fullType = 'iMeds.PlasmaBagABN',
    },
    ABP = {
        alias = 'PlasmaBagABP',
        fullType = 'iMeds.PlasmaBagABP',
    },
    AN = {
        alias = 'PlasmaBagAN',
        fullType = 'iMeds.PlasmaBagAN',
    },
    AP = {
        alias = 'PlasmaBagAP',
        fullType = 'iMeds.PlasmaBagAP',
    },
    BN = {
        alias = 'PlasmaBagBN',
        fullType = 'iMeds.PlasmaBagBN',
    },
    BP = {
        alias = 'PlasmaBagBP',
        fullType = 'iMeds.PlasmaBagBP',
    },
    ON = {
        alias = 'PlasmaBagON',
        fullType = 'iMeds.PlasmaBagON',
    },
    OP = {
        alias = 'PlasmaBagOP',
        fullType = 'iMeds.PlasmaBagOP',
    },
}

---@param fullType string
---@return boolean
function PlasmaBag:haveFullType(fullType)
    for _, data in pairs(self) do
        if type(data) == 'table' and fullType == data.fullType then
            return true
        end
    end

    return false
end

---@param fullType string
---@return string|nil
function PlasmaBag:getBloodTypeByFullType(fullType)
    for bloodType, data in pairs(self) do
        if type(data) == 'table' and fullType == data.fullType then
            return bloodType
        end
    end

    return nil
end