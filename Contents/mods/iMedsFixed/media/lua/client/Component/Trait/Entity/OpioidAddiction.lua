OpioidAddictionTrait = {
    alias = 'OpioidAddiction',
    name = getText('UI_Trait_OpioidAddiction_Name'),
    description = getText('UI_Trait_OpioidAddiction_Description'),
    cost = -10,
    freeRecipes = {},
    xpBoosts = {
        Perks.Strength,
        Perks.Fitness,
    },
    xpBoostValues = {
        [Perks.Strength] = -2,
        [Perks.Fitness] = -2,
    },
    mutualExclusives = {
        'HighPainThreshold',
        'LowPainThreshold',
        'FastHealer',
        'Obese',
        'Overweight',
        'Fit',
    },
}

ZCore:getContainer():register(
    require 'Component/Trait/Entity/Trait',
    'imeds.trait.entity.opioid_addiction',
    {
        OpioidAddictionTrait
    },
    'imeds.trait.entity'
)

---@type SideEffectStorage
local sideEffectStorage
local opioidAddiction
local sweating
local tachycardia

local effect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    if not getSpecificPlayer(0):HasTrait(OpioidAddictionTrait.alias) then
        return false
    end

    HighPainThreshold.effect()

    local modifier = 0.00035
    if Survivor:getBlood():getDrugs()[Morphine.alias] ~= nil and Survivor:getBlood():getDrugs()[Morphine.alias].isActive then
        modifier = -0.15
    end

    if sideEffectStorage == nil then
        sideEffectStorage = ZCore:getContainer():get('imeds.side_effect.storage.side_effect_storage')
        ---@type SideEffect
        opioidAddiction = sideEffectStorage:getByAlias(OpioidAddiction.alias)
        ---@type SideEffect
        sweating = sideEffectStorage:getByAlias(Sweating.alias)
        ---@type SideEffect
        tachycardia = sideEffectStorage:getByAlias(Tachycardia.alias)
    end

    Survivor:setStressFromOpioidAddiction(Survivor:getStressFromOpioidAddiction() + modifier * getGameTime():getMultiplier())
    if Survivor:getStressFromOpioidAddiction() > 25 then
        Survivor:addSideEffect(opioidAddiction, 1)
    end

    if Survivor:getStressFromOpioidAddiction() > 40 then
        Survivor:addSideEffect(opioidAddiction, 2)
        Survivor:addSideEffect(sweating, 1)
        Survivor:addSideEffect(tachycardia, 1)
    end

    if Survivor:getStressFromOpioidAddiction() > 70 then
        Survivor:addSideEffect(opioidAddiction, 3)
        Survivor:addSideEffect(sweating, 2)
        Survivor:addSideEffect(tachycardia, 2)
    end

    if Survivor:getStressFromOpioidAddiction() > 100 then
        Survivor:setStressFromOpioidAddiction(100)
    end

    if Survivor:getStressFromOpioidAddiction() < 0 then
        Survivor:setStressFromOpioidAddiction(0)
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Trait' then
        Events.OnTick.Add(effect)
    end
end)