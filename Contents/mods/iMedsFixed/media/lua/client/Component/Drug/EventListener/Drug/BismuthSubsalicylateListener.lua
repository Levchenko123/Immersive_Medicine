local normalEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[BismuthSubsalicylate.alias] == nil then
        return false
    end

    if Survivor:getBlood():getDrugs()[BismuthSubsalicylate.alias].isActive then
        ---@type DrugStorage
        local drugStorage = ZCore:getContainer():get('imeds.drug.storage.drug_storage')
        for _, drug in pairs(drugStorage:findAll()) do
            if Survivor:getBlood():getDrugs()[drug:getAlias()] ~= nil
                and Survivor:getBlood():getDrugs()[drug:getAlias()].isOverdose
            then
                return false
            end
        end

        local foodSicknessLevel = Survivor:getFoodSicknessLevel() - ZomboidGlobals.FoodSicknessDecrease * 0.75 * getGameTime():getMultiplier()
        Survivor:setFoodSicknessLevel(foodSicknessLevel)
    end
end

local overdoseEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[BismuthSubsalicylate.alias] == nil then
        return false
    end

    if not Survivor:getBlood():getDrugs()[BismuthSubsalicylate.alias].isOverdose then
        return false
    end

    if not Survivor:getBlood():getDrugs()[BismuthSubsalicylate.alias].isOverdoseEffectApplied then
        if Survivor:getFoodSicknessLevel() < 80 then
            Survivor:setFoodSicknessLevel(80)
        end

        Survivor:getBlood():getDrugs()[BismuthSubsalicylate.alias].isOverdoseEffectApplied = true
    end
end

Events.OnTick.Add(normalEffect)
Events.OnTick.Add(overdoseEffect)