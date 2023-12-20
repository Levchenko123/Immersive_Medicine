LowPainThreshold = {
    alias = 'LowPainThreshold',
    name = getText('UI_Trait_LowPainThreshold_Name'),
    description = getText('UI_Trait_LowPainThreshold_Description'),
    cost = -6,
    freeRecipes = {},
    xpBoosts = {},
    xpBoostValues = {},
    mutualExclusives = {},
}

ZCore:getContainer():register(
    require 'Component/Trait/Entity/Trait',
    'imeds.trait.entity.low_pain_threshold',
    {
        LowPainThreshold
    },
    'imeds.trait.entity'
)

local effect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    if not getSpecificPlayer(0):HasTrait(LowPainThreshold.alias) then
        return false
    end

    getSpecificPlayer(0):getBodyDamage():setInitialWoundPain(100)
    getSpecificPlayer(0):getBodyDamage():setInitialScratchPain(30)
    getSpecificPlayer(0):getBodyDamage():setInitialThumpPain(25)
    getSpecificPlayer(0):getBodyDamage():setInitialBitePain(40)
    getSpecificPlayer(0):getBodyDamage():setContinualPainIncrease(0.00125)
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Trait' then
        Events.OnTick.Add(effect)
    end
end)