HighPainThreshold = {
    alias = 'HighPainThreshold',
    name = getText('UI_Trait_HighPainThreshold_Name'),
    description = getText('UI_Trait_HighPainThreshold_Description'),
    cost = 6,
    freeRecipes = {},
    xpBoosts = {},
    xpBoostValues = {},
    mutualExclusives = {
        'LowPainThreshold',
    },
}

ZCore:getContainer():register(
    require 'Component/Trait/Entity/Trait',
    'imeds.trait.entity.high_pain_threshold',
    {
        HighPainThreshold
    },
    'imeds.trait.entity'
)

HighPainThreshold.effect = function()
    if Survivor:getPainReduction() < 15 then
        Survivor:setPainReduction(15)
    end

    -- -25% to pain
    getSpecificPlayer(0):getBodyDamage():setInitialWoundPain(60)
    getSpecificPlayer(0):getBodyDamage():setInitialScratchPain(13)
    getSpecificPlayer(0):getBodyDamage():setInitialThumpPain(10)
    getSpecificPlayer(0):getBodyDamage():setInitialBitePain(18)
    getSpecificPlayer(0):getBodyDamage():setContinualPainIncrease(0.00075)
end

local effect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    if not getSpecificPlayer(0):HasTrait(HighPainThreshold.alias) then
        return false
    end

    HighPainThreshold.effect()
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Trait' then
        Events.OnTick.Add(effect)
    end
end)