local removeProps = function()
    if Survivor:isDeadOrNotExist() then
        return false
    end

    if Survivor:haveItem(BloodVolumeReducer.fullType) then
        Survivor:removeItem(BloodVolumeReducer.fullType)

        triggerEvent(ImmersiveMedicineEvent.iMedsBloodVolumeReducerDeleted)
    end

    if Survivor:haveItem(BloodVolumeIncreaser.fullType) then
        triggerEvent(ImmersiveMedicineEvent.iMedsBloodVolumeIncreaserDeleted, Survivor:getItem(BloodVolumeIncreaser.fullType):getModData())

        Survivor:removeItem(BloodVolumeIncreaser.fullType)
    end

    if Survivor:haveItem(BloodTester.fullType) then
        triggerEvent(ImmersiveMedicineEvent.iMedsBloodTesterDeleted)

        Survivor:removeItem(BloodTester.fullType)
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Blood' then
        Events.OnTickEvenPaused.Add(removeProps)
    end
end)

