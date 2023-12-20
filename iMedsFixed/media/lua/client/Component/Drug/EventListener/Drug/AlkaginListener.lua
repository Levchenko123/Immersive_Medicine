local normalEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Alkagin.alias] == nil then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Alkagin.alias].isActive then
        return false
    end

    if Survivor:getPainReduction() < 35 then
        Survivor:setPainReduction(35)
    end
end

local overdoseEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Alkagin.alias] == nil then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Alkagin.alias].isOverdose then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Alkagin.alias].isOverdoseEffectApplied then
        if Survivor:getFoodSicknessLevel() < 80 then
            Survivor:setFoodSicknessLevel(80)
        end

        Survivor:getBlood():getDrugs()[Alkagin.alias].isOverdoseEffectApplied = true
    end
end

Events.OnTick.Add(normalEffect)
Events.OnTick.Add(overdoseEffect)