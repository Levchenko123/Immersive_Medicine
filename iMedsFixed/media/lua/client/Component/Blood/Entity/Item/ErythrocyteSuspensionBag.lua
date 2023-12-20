ErythrocyteSuspensionBag = {
    ABN = {
        alias = 'ErythrocyteSuspensionBagABN',
        fullType = 'iMeds.ErythrocyteSuspensionBagABN',
    },
    ABP = {
        alias = 'ErythrocyteSuspensionBagABP',
        fullType = 'iMeds.ErythrocyteSuspensionBagABP',
    },
    AN = {
        alias = 'ErythrocyteSuspensionBagAN',
        fullType = 'iMeds.ErythrocyteSuspensionBagAN',
    },
    AP = {
        alias = 'ErythrocyteSuspensionBagAP',
        fullType = 'iMeds.ErythrocyteSuspensionBagAP',
    },
    BN = {
        alias = 'ErythrocyteSuspensionBagBN',
        fullType = 'iMeds.ErythrocyteSuspensionBagBN',
    },
    BP = {
        alias = 'ErythrocyteSuspensionBagBP',
        fullType = 'iMeds.ErythrocyteSuspensionBagBP',
    },
    ON = {
        alias = 'ErythrocyteSuspensionBagON',
        fullType = 'iMeds.ErythrocyteSuspensionBagON',
    },
    OP = {
        alias = 'ErythrocyteSuspensionBagOP',
        fullType = 'iMeds.ErythrocyteSuspensionBagOP',
    },
}

---@param fullType string
---@return boolean
function ErythrocyteSuspensionBag:haveFullType(fullType)
    for _, data in pairs(self) do
        if type(data) == 'table' and fullType == data.fullType then
            return true
        end
    end

    return false
end

---@param fullType string
---@return string|nil
function ErythrocyteSuspensionBag:getBloodTypeByFullType(fullType)
    for bloodType, data in pairs(self) do
        if type(data) == 'table' and fullType == data.fullType then
            return bloodType
        end
    end

    return nil
end