OnBloodTesterDeleteListener = {}

local onBloodTesterDeleteListener = function(data)
    local bloodTestingKit = InventoryItemFactory.CreateItem(BloodTestingKit.fullType)
    bloodTestingKit:setName(Survivor:getBlood():getGroup():getName())
    bloodTestingKit:setUsedDelta(0)
    getSpecificPlayer(0):getSquare():AddWorldInventoryItem(bloodTestingKit, 0.5, 0.5, 0)

    Survivor:getBlood():reduceVolume(5)
    Survivor:setIsKnowOwnBloodGroup(true)
end

Events[ImmersiveMedicineEvent.iMedsBloodTesterDeleted].Add(onBloodTesterDeleteListener)