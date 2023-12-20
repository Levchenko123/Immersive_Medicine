local normalEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Umifenovir.alias] == nil then
        return false
    end

    if Survivor:getBlood():getDrugs()[Umifenovir.alias].isActive then
        if not Survivor:isInfected() then
            return false
        end

        if getSpecificPlayer(0):getModData().survivor.infectionMortalityDuration == nil then
            getSpecificPlayer(0):getModData().survivor.infectionMortalityDuration = Survivor:getInfectionMortalityDuration() * 1.5
        end

        if Survivor:getInfectionMortalityDuration() < getSpecificPlayer(0):getModData().survivor.infectionMortalityDuration then
            local mortalityDuration = Survivor:getInfectionMortalityDuration() + 0.00015 * getGameTime():getMultiplier()
            Survivor:setInfectionMortalityDuration(mortalityDuration)
        end
    end
end

local overdoseEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Umifenovir.alias] == nil then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Umifenovir.alias].isOverdose then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Umifenovir.alias].isOverdoseEffectApplied then
        local duration = Umifenovir.durationByDosageForm[DosageForm.Oral.Pill.alias] / 2 * TimeHandler.durationModifier
        Survivor:getBlood():getDrugs()[Umifenovir.alias].duration = Survivor:getBlood():getDrugs()[Umifenovir.alias].duration - duration

        Survivor:getBlood():getDrugs()[Umifenovir.alias].isOverdoseEffectApplied = true
    end
end

Events.OnTick.Add(normalEffect)
Events.OnTick.Add(overdoseEffect)