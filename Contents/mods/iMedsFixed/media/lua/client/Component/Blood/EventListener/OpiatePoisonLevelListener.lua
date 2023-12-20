local updateOpiatePoisonLevel = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    Survivor:getBlood():setOpiatePoisonLevel(Survivor:getBlood():getOpiatePoisonLevel() - ZomboidGlobals.FoodSicknessDecrease * getGameTime():getMultiplier())

    if Survivor:getBlood():getOpiatePoisonLevel() < 0 then
        Survivor:getBlood():setOpiatePoisonLevel(0)
    end

    if Survivor:getBlood():getOpiatePoisonLevel() > 100 then
        Survivor:getBlood():setOpiatePoisonLevel(100)
    end

    if Survivor:getBlood():getOpiatePoisonLevel() > 0 then
        Survivor:setFoodSicknessLevel(Survivor:getBlood():getOpiatePoisonLevel())
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Blood' then
        Events.OnTick.Add(updateOpiatePoisonLevel)
    end
end)