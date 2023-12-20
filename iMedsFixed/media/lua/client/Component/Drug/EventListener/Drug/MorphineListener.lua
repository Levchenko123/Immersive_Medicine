local normalEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Morphine.alias] == nil then
        return false
    end

    if Survivor:getBlood():getDrugs()[Morphine.alias].isActive then
        for _, index in pairs(BodyPart) do
            Survivor:setAdditionalBodyPartPainByType(index, 0)
        end

        if Survivor:getPainReduction() < 70 then
            Survivor:setPainReduction(70)
        end

        Survivor:setStress(0)
        Survivor:setUnhappynessLevel(0)
        Survivor:setBoredomLevel(0)
        Survivor:setPanic(0)

        local drunkennessModifier = 30
        if getSpecificPlayer(0):HasTrait(OpioidAddictionTrait.alias) then
            drunkennessModifier = 15
        end

        local drunkenness = Survivor:getBlood():getDrugs()[Morphine.alias].dose * drunkennessModifier
        if drunkenness > 100 then
            drunkenness = 100
        end

        if Survivor:getDrunkenness() < drunkenness then
            Survivor:setDrunkenness(drunkenness)
        end
    end
end

local overdoseEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Morphine.alias] == nil then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Morphine.alias].isOverdose then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Morphine.alias].isOverdoseEffectApplied then
        Survivor:getBlood():setOpiatePoisonLevel(100)
        Survivor:setEndurance(0)
        Survivor:setFatigue(1)

        if ZombRand(1, 100) > 70 and not getSpecificPlayer(0):HasTrait(OpioidAddictionTrait.alias) then
            getSpecificPlayer(0):getTraits():add(OpioidAddictionTrait.alias)
        end

        Survivor:getBlood():getDrugs()[Morphine.alias].isOverdoseEffectApplied = true
    end
end

Events.OnTick.Add(normalEffect)
Events.OnTick.Add(overdoseEffect)