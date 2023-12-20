OpioidAddiction = {
    alias = 'OpioidAddiction',
    name = getText('UI_SideEffect_OpioidAddiction_Name'),
    description = {
        getText('UI_SideEffect_OpioidAddiction_Lvl_1_Description'),
        getText('UI_SideEffect_OpioidAddiction_Lvl_2_Description'),
        getText('UI_SideEffect_OpioidAddiction_Lvl_3_Description'),
    },
    maxLevel = 3,
    isDurationEnabled = false,
    duration = 0,
    exclusives = {},
}

ZCore:getContainer():register(
    require 'Component/SideEffect/Entity/SideEffect',
    'imeds.side_effect.entity.opioid_addiction',
    {
        OpioidAddiction,
    },
    'imeds.side_effect.entity'
)

local maxStress = { 0.26, 0.6, 0.76 }

local effect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    local sideEffect = Survivor:getSideEffects()[OpioidAddiction.alias]
    if sideEffect == nil then
        return false
    end

    if Survivor:getFakeInfectionLevel() < 0 then
        Survivor:setFakeInfectionLevel(0)
    end

    if not sideEffect.isActive then
        Survivor:setFakeInfectionLevel(Survivor:getFakeInfectionLevel() - 0.05 * getGameTime():getMultiplier())

        return false
    end

    if sideEffect.level > 0 then
        Survivor:setUnhappynessLevel(Survivor:getUnhappynessLevel() + 0.004 * getGameTime():getMultiplier())
        Survivor:setStress(Survivor:getStress() + 0.00005 * getGameTime():getMultiplier())
        Survivor:setAdditionalBodyPartPainByType(BodyPart.Head, 20)
    end

    if sideEffect.level > 1 then
        Survivor:setAdditionalBodyPartPainByType(BodyPart.Head, 40)
    end

    if sideEffect.level > 2 then
        Survivor:setFakeInfectionLevel(Survivor:getFakeInfectionLevel() + 0.015 * getGameTime():getMultiplier())
        if Survivor:getFakeInfectionLevel() > 100 then
            Survivor:setFakeInfectionLevel(100)
        end

        Survivor:setAdditionalBodyPartPainByType(BodyPart.Head, 50)
        Survivor:setAdditionalBodyPartPainByType(BodyPart.Hand_L, 30)
        Survivor:setAdditionalBodyPartPainByType(BodyPart.Hand_R, 30)
        Survivor:setAdditionalBodyPartPainByType(BodyPart.ForeArm_L, 30)
        Survivor:setAdditionalBodyPartPainByType(BodyPart.ForeArm_R, 30)
    end

    if Survivor:getStress() <= maxStress[sideEffect.level] then
        Survivor:setStress(maxStress[sideEffect.level])
    end

    if Survivor:getStress() > 1 then
        Survivor:setStress(1)
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'SideEffect' then
        Events.OnTick.Add(effect)
    end
end)