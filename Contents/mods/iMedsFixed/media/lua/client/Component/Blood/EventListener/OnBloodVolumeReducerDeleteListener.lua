local onBloodVolumeReducerDeleteListener = function()
    local fullBloodBag = BloodBagCreator:new():createFull()
    if Survivor:isKnowOwnBloodGroup() then
        fullBloodBag:setName(string.format('%s (%s)', fullBloodBag:getName(), Survivor:getBlood():getGroup():getName()))
    end

    getSpecificPlayer(0):getSquare():AddWorldInventoryItem(fullBloodBag, 0.5, 0.5, 0)

    if not SandboxVars.ImmersiveMedicine.IsBloodSystemActive then
        return false
    end

    Survivor:getBlood():reduceVolume(fullBloodBag:getModData().blood.volume)
    Survivor:setEndurance(Survivor:getEndurance() - 0.35);
    Survivor:setFatigue(Survivor:getFatigue() + 0.45);
end

Events[ImmersiveMedicineEvent.iMedsBloodVolumeReducerDeleted].Add(onBloodVolumeReducerDeleteListener)