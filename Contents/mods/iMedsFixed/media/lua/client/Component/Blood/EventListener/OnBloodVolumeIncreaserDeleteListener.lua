local onBloodVolumeIncreaserDeleteListener = function(data)
    if not SandboxVars.ImmersiveMedicine.IsBloodSystemActive then
        return false
    end

    local additionalPoisonLevel = data.blood.isFresh and 0 or 50
    if data.blood.isRotten then
        additionalPoisonLevel = 100
    end

    local levelModifier = Survivor:getBlood():getVolume() / data.blood.volume

    Survivor:getBlood():addVolume(data.blood.volume)
    Survivor:setDrunkenness(data.blood.donor.drunkennessLevel / levelModifier)
    Survivor:setPoisonLevel(data.blood.donor.poisonLevel / levelModifier + additionalPoisonLevel)
    Survivor:setIsInfected(data.blood.donor.isInfected)

    if not SandboxVars.ImmersiveMedicine.IsBloodTypeSystemActive then
        return false
    end

    if not Survivor:getBlood():getGroup():hasCompatibility(data.blood.group) then
        Survivor:setFoodSicknessLevel(100)
        Survivor:setPoisonLevel(100)
        Survivor:setEndurance(0)
        Survivor:setFatigue(1)
        Survivor:setDrunkenness(100)
    end
end

Events[ImmersiveMedicineEvent.iMedsBloodVolumeIncreaserDeleted].Add(onBloodVolumeIncreaserDeleteListener)