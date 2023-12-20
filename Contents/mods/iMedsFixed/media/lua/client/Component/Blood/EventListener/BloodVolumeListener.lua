local updateBloodVolume = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    if not SandboxVars.ImmersiveMedicine.IsBloodSystemActive then
        return false
    end

    local bloodVolumeReduceModifier = 0
    for _, bodyPartType in pairs(BodyPart) do
        local bodyPart = Survivor:getBodyPartByType(bodyPartType)

        if bodyPart:bleeding() then
            bloodVolumeReduceModifier = bloodVolumeReduceModifier + SandboxVars.ImmersiveMedicine.BloodVolumeReduceModifier / 1000
        end

        if bodyPart:bleeding() and (bodyPart:isDeepWounded() or bodyPart:bitten() or bodyPart:haveGlass() or bodyPart:haveBullet() or bodyPart:isCut()) then
            bloodVolumeReduceModifier = bloodVolumeReduceModifier + SandboxVars.ImmersiveMedicine.BloodVolumeReduceModifier / 1000 * 2
        end
    end

    Survivor:getBlood():reduceVolume(bloodVolumeReduceModifier * getGameTime():getMultiplier())

    if bloodVolumeReduceModifier == 0 then
        local hungerLevel = getSpecificPlayer(0):getMoodles():getMoodleLevel(MoodleType.Hungry)
        local thirstLevel = getSpecificPlayer(0):getMoodles():getMoodleLevel(MoodleType.Thirst)
        local bloodVolumeIncreasingModifier = (4 - hungerLevel) / 1200 + (4 - thirstLevel) / 1200
        Survivor:getBlood():addVolume(bloodVolumeIncreasingModifier * SandboxVars.ImmersiveMedicine.BloodVolumeIncreaseModifier * getGameTime():getMultiplier())
    end

    if Survivor:getBlood():getVolume() > Blood.maxVolume then
        Survivor:getBlood():setVolume(Blood.maxVolume)
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Blood' then
        Events.OnTick.Add(updateBloodVolume)
    end
end)

