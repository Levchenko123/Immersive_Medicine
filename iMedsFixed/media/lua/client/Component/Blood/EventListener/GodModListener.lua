---@type SideEffectStorage
local sideEffectStorage

local resetAll = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    if getSpecificPlayer(0):isGodMod() then
        if sideEffectStorage == nil then
            sideEffectStorage = ZCore:getContainer():get('imeds.side_effect.storage.side_effect_storage')
        end

        getSpecificPlayer(0):setBlockMovement(false)
        getSpecificPlayer(0):setBannedAttacking(false)
        Survivor:getBlood():setVolume(Blood.maxVolume)

        ---@type DrugStorage
        local drugStorage = ZCore:getContainer():get('imeds.drug.storage.drug_storage')
        for _, drug in pairs(drugStorage:findAll()) do
            if Survivor:getBlood():getDrugs()[drug:getAlias()] ~= nil then
                Survivor:getBlood():getDrugs()[drug:getAlias()].onset = 0
                Survivor:getBlood():getDrugs()[drug:getAlias()].duration = 0
                Survivor:getBlood():getDrugs()[drug:getAlias()].dose = 0
                Survivor:getBlood():getDrugs()[drug:getAlias()].isActive = false
                Survivor:getBlood():getDrugs()[drug:getAlias()].isOverdose = false
                Survivor:getBlood():getDrugs()[drug:getAlias()].isOverdoseEffectApplied = false
            end
        end

        for _, sideEffect in pairs(sideEffectStorage:findAll()) do
            if Survivor:getSideEffects()[sideEffect:getAlias()] ~= nil then
                Survivor:removeSideEffect(sideEffect:getAlias())
            end
        end

        Survivor:setStressFromOpioidAddiction(0)
        Survivor:getBlood():setOpiatePoisonLevel(0)
        Survivor:getBlood():setPulse(Blood.pulse.normal)
        Survivor:getBlood():getPressure():setSystolic(BloodPressure.systolic.normal)
        Survivor:getBlood():getPressure():setDiastolic(BloodPressure.diastolic.normal)
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Blood' then
        Events.OnTick.Add(resetAll)
    end
end)

