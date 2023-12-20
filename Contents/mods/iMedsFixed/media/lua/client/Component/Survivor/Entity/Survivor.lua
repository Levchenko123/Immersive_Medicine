Survivor = {}

---@return table<string, any>
function Survivor:getModData()
    return getSpecificPlayer(0):getModData()
end

---@return number
function Survivor:getPain()
    return getSpecificPlayer(0):getStats():getPain()
end

---@param value number
---@return void
function Survivor:setPain(value)
    getSpecificPlayer(0):getStats():setPain(value)
end

---@return number
function Survivor:getDrunkenness()
    return getSpecificPlayer(0):getStats():getDrunkenness()
end

---@return void
---@param value number
function Survivor:setDrunkenness(value)
    getSpecificPlayer(0):getStats():setDrunkenness(value)
end

---@return number
function Survivor:getEndurance()
    return getSpecificPlayer(0):getStats():getEndurance()
end

---@return void
---@param value number
function Survivor:setEndurance(value)
    getSpecificPlayer(0):getStats():setEndurance(value)
end

---@return number
function Survivor:getFatigue()
    return getSpecificPlayer(0):getStats():getFatigue()
end

---@return void
---@param value number
function Survivor:setFatigue(value)
    getSpecificPlayer(0):getStats():setFatigue(value)
end

---@return number
function Survivor:getFoodSicknessLevel()
    return getSpecificPlayer(0):getBodyDamage():getFoodSicknessLevel()
end

---@return void
---@param value number
function Survivor:setFoodSicknessLevel(value)
    getSpecificPlayer(0):getBodyDamage():setFoodSicknessLevel(value)
end

---@return number
function Survivor:getFakeInfectionLevel()
    return getSpecificPlayer(0):getBodyDamage():getFakeInfectionLevel()
end

---@return void
---@param value number
function Survivor:setFakeInfectionLevel(value)
    getSpecificPlayer(0):getBodyDamage():setFakeInfectionLevel(value)
end

---@return number
function Survivor:getThirst()
    return getSpecificPlayer(0):getStats():getThirst()
end

---@return void
---@param value number
function Survivor:setThirst(value)
    getSpecificPlayer(0):getStats():setThirst(value)
end

---@return number
function Survivor:getHunger()
    return getSpecificPlayer(0):getStats():getHunger()
end

---@param value number
---@return void
function Survivor:setHunger(value)
    getSpecificPlayer(0):getStats():setHunger(value)
end

---@param type string
---@return table
function Survivor:getBodyPartByType(type)
    return getSpecificPlayer(0):getBodyDamage():getBodyPart(type)
end

---@param type number
---@return number
function Survivor:getAdditionalBodyPartPainByType(type)
    return Survivor:getBodyPartByType(type):getAdditionalPain()
end

---@param type number
---@param value number
---@return void
function Survivor:setAdditionalBodyPartPainByType(type, value)
    Survivor:getBodyPartByType(type):setAdditionalPain(value)
end

---@return number
function Survivor:getPainReduction()
    return getSpecificPlayer(0):getBodyDamage():getPainReduction()
end

---@param value number
---@return void
function Survivor:setPainReduction(value)
    getSpecificPlayer(0):getBodyDamage():setPainReduction(value)
end

---@return number
function Survivor:getPainReductionFromMeds()
    return getSpecificPlayer(0):getBodyDamage():getPainReductionFromMeds()
end

---@param value number
---@return void
function Survivor:setPainReductionFromMeds(value)
    getSpecificPlayer(0):getBodyDamage():setPainReductionFromMeds(value)
end

---@param type number
---@return number
function Survivor:getBodyPartHealthByType(type)
    return Survivor:getBodyPartByType(type):getHealth()
end

---@param type number
---@param value number
---@return void
function Survivor:setBodyPartHealthByType(type, value)
    Survivor:getBodyPartByType(type):SetHealth(value)
end

---@return number
function Survivor:getStress()
    return getSpecificPlayer(0):getStats():getStress()
end

---@return void
---@param value number
function Survivor:setStress(value)
    getSpecificPlayer(0):getStats():setStress(value)
end

---@return number
function Survivor:getPoisonLevel()
    return getSpecificPlayer(0):getBodyDamage():getPoisonLevel()
end

---@return void
---@param value number
function Survivor:setPoisonLevel(value)
    getSpecificPlayer(0):getBodyDamage():setPoisonLevel(value)
end

---@return number
function Survivor:getPanic()
    return getSpecificPlayer(0):getStats():getPanic()
end

---@return void
---@param value number
function Survivor:setPanic(value)
    getSpecificPlayer(0):getStats():setPanic(value)
end

---@return number
function Survivor:getTemperature()
    return getSpecificPlayer(0):getBodyDamage():getTemperature()
end

---@return void
---@param value number
function Survivor:setTemperature(value)
    getSpecificPlayer(0):getBodyDamage():setTemperature(value)
end

---@return number
function Survivor:getInfectionLevel()
    return getSpecificPlayer(0):getBodyDamage():getInfectionLevel()
end

---@return void
---@param value number
function Survivor:setWetness(value)
    getSpecificPlayer(0):getBodyDamage():setWetness(value)
end

---@return number
function Survivor:getWetness()
    return getSpecificPlayer(0):getBodyDamage():getWetness()
end

---@return void
---@param value number
function Survivor:setInfectionLevel(value)
    getSpecificPlayer(0):getBodyDamage():setInfectionLevel(value)
end

---@return number
function Survivor:getGeneralHealth()
    return getSpecificPlayer(0):getBodyDamage():getOverallBodyHealth()
end

---@return void
---@param value number
function Survivor:addGeneralHealth(value)
    getSpecificPlayer(0):getBodyDamage():AddGeneralHealth(value)
end

---@return void
---@param value number
function Survivor:reduceGeneralHealth(value)
    getSpecificPlayer(0):getBodyDamage():ReduceGeneralHealth(value)
end

---@return table
function Survivor:getPrimaryHandItem()
    return getSpecificPlayer(0):getPrimaryHandItem()
end

---@return void
---@param item table
function Survivor:setPrimaryHandItem(item)
    getSpecificPlayer(0):setPrimaryHandItem(item)
end

---@return boolean
function Survivor:isBannedAttacking()
    return getSpecificPlayer(0):isBannedAttacking()
end

---@return void
---@param bool boolean
function Survivor:setBannedAttacking(bool)
    getSpecificPlayer(0):setBannedAttacking(bool)
end

---@return boolean
function Survivor:isMoving()
    return getSpecificPlayer(0):getPlayerMoveDir():getLength() ~= 0
end

---@return boolean
function Survivor:isInfected()
    return getSpecificPlayer(0):getBodyDamage():IsInfected()
end

---@return void
---@param bool boolean
function Survivor:setIsInfected(bool)
    getSpecificPlayer(0):getBodyDamage():setInf(bool)
end

---@return table|nil
---@param fullType string
function Survivor:getItem(fullType)
    return getSpecificPlayer(0):getInventory():FindAndReturn(fullType)
end

---@return table
---@param fullType string
function Survivor:addItem(fullType)
    return getSpecificPlayer(0):getInventory():AddItem(fullType)
end

---@return void
---@param fullType string
function Survivor:removeItem(fullType)
    if getSpecificPlayer(0):getInventory():containsWithModule(fullType) then
        local item = getSpecificPlayer(0):getInventory():FindAndReturn(fullType)
        getSpecificPlayer(0):getInventory():Remove(item)
    end
end

---@param fullType string
---@return boolean
function Survivor:haveItem(fullType)
    return getSpecificPlayer(0):getInventory():containsWithModule(fullType)
end

---@return number
function Survivor:getUnhappynessLevel()
    return getSpecificPlayer(0):getBodyDamage():getUnhappynessLevel()
end

---@return void
---@param value number
function Survivor:setUnhappynessLevel(value)
    getSpecificPlayer(0):getBodyDamage():setUnhappynessLevel(value)
end

---@return number
function Survivor:getBoredomLevel()
    return getSpecificPlayer(0):getBodyDamage():getBoredomLevel()
end

---@return void
---@param value number
function Survivor:setBoredomLevel(value)
    getSpecificPlayer(0):getBodyDamage():setBoredomLevel(value);
end

---@return number
function Survivor:getInfectionMortalityDuration()
    return getSpecificPlayer(0):getBodyDamage():getInfectionMortalityDuration()
end

---@return void
---@param value number
function Survivor:setInfectionMortalityDuration(value)
    getSpecificPlayer(0):getBodyDamage():setInfectionMortalityDuration(value)
end

---@return boolean
function Survivor:isInitialized()
    return getSpecificPlayer(0) ~= nil
        and getSpecificPlayer(0):getModData().survivor ~= nil
        and getSpecificPlayer(0):getModData().survivor.isInitialized
end

---@param bool boolean
---@return void
function Survivor:setIsInitialized(bool)
    getSpecificPlayer(0):getModData().survivor.isInitialized = bool
end

---@return Blood
function Survivor:getBlood()
    return require 'Component/Blood/Entity/Blood'
end

---@return boolean
function Survivor:isKnowOwnBloodGroup()
    return getSpecificPlayer(0):getModData().survivor.isKnowOwnBloodGroup
end

---@param bool boolean
---@return void
function Survivor:setIsKnowOwnBloodGroup(bool)
    getSpecificPlayer(0):getModData().survivor.isKnowOwnBloodGroup = bool
end

---@return number
function Survivor:getStressFromOpioidAddiction()
    if getSpecificPlayer(0):getModData().survivor.stressFromOpioidAddiction == nil then
        getSpecificPlayer(0):getModData().survivor.stressFromOpioidAddiction = 0
    end

    return getSpecificPlayer(0):getModData().survivor.stressFromOpioidAddiction
end

---@return void
---@param value number
function Survivor:setStressFromOpioidAddiction(value)
    getSpecificPlayer(0):getModData().survivor.stressFromOpioidAddiction = value
end

---@return table
function Survivor:getSideEffects()
    if getSpecificPlayer(0):getModData().survivor.sideEffects == nil then
        getSpecificPlayer(0):getModData().survivor.sideEffects = {}
    end

    return getSpecificPlayer(0):getModData().survivor.sideEffects
end

---@param sideEffect SideEffect
---@param level number
function Survivor:addSideEffect(sideEffect, level)
    if Survivor:getSideEffects()[sideEffect:getAlias()] == nil then
        Survivor:getSideEffects()[sideEffect:getAlias()] = {}
    end

    if Survivor:getSideEffects()[sideEffect:getAlias()].isActive
        and Survivor:getSideEffects()[sideEffect:getAlias()].level == level
    then
        return
    end

    if level < 0 then
        level = 1
    end

    if level > sideEffect:getMaxLevel() then
        level = sideEffect:getMaxLevel()
    end

    Survivor:getSideEffects()[sideEffect:getAlias()].isActive = true
    Survivor:getSideEffects()[sideEffect:getAlias()].isDurationEnabled = sideEffect:isDurationEnabled()
    Survivor:getSideEffects()[sideEffect:getAlias()].duration = sideEffect:getDuration()
    Survivor:getSideEffects()[sideEffect:getAlias()].level = level

    local exclusives = sideEffect:getExclusives()
    if #exclusives > 0 then
        for _, alias in ipairs(exclusives) do
            Survivor:removeSideEffect(alias)
        end
    end
end

---@param alias string
function Survivor:removeSideEffect(alias)
    if Survivor:getSideEffects()[alias] == nil then
        Survivor:getSideEffects()[alias] = {}
    end

    Survivor:getSideEffects()[alias].isActive = false
    Survivor:getSideEffects()[alias].isDurationEnabled = false
    Survivor:getSideEffects()[alias].duration = 0
    Survivor:getSideEffects()[alias].level = 0
end

---@param index number
function Survivor:getRequiredWaterByBodyPartIndex(index)
    local units = 0
    local humanVisual = getSpecificPlayer(0):getHumanVisual()
    local bodyPart = BloodBodyPartType.FromIndex(index)

    if humanVisual:getBlood(bodyPart) + humanVisual:getDirt(bodyPart) > 0 then
        units = units + 1
    end

    return units
end

---@return boolean
function Survivor:isDeadOrNotExist()
    return not getSpecificPlayer(0) or getSpecificPlayer(0):isDead()
end

return Survivor