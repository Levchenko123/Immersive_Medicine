local normalEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Nasivion.alias] == nil then
        return false
    end

    if Survivor:getBlood():getDrugs()[Nasivion.alias].isActive then
        if not getSpecificPlayer(0):getBodyDamage():isHasACold() then
            return false
        end

        --- 1 - sneeze
        --- 2 - cough
        --- 3 - tissue sneeze
        --- 4 - tissue cough
        if Survivor:getBlood():getDrugs()[Butamirate.alias] ~= nil and Survivor:getBlood():getDrugs()[Butamirate.alias].isActive then
            getSpecificPlayer(0):getBodyDamage():setSneezeCoughActive(5)

            return
        end

        if getSpecificPlayer(0):getBodyDamage():getTimeToSneezeOrCough() <= 1 then
            getSpecificPlayer(0):getBodyDamage():setSneezeCoughActive(5)
        end

        if getSpecificPlayer(0):getBodyDamage():getTimeToSneezeOrCough() <= 1 and getSpecificPlayer(0):getMoodles():getMoodleLevel(MoodleType.HasACold) > 3 then
            getSpecificPlayer(0):getBodyDamage():setSneezeCoughActive(2)

            if getSpecificPlayer(0):hasEquipped('Tissue') then
                getSpecificPlayer(0):getBodyDamage():setSneezeCoughActive(4)
            end
        end

        if getSpecificPlayer(0):IsSpeaking() then
            getSpecificPlayer(0):getBodyDamage():setSneezeCoughActive(0)

            if getSpecificPlayer(0):getMoodles():getMoodleLevel(MoodleType.HasACold) == 2 then
                local result = getSpecificPlayer(0):getBodyDamage():getMildColdSneezeTimerMin() + ZombRand(1, getSpecificPlayer(0):getBodyDamage():getMildColdSneezeTimerMax() - getSpecificPlayer(0):getBodyDamage():getMildColdSneezeTimerMin())
                getSpecificPlayer(0):getBodyDamage():setTimeToSneezeOrCough(result);
            elseif getSpecificPlayer(0):getMoodles():getMoodleLevel(MoodleType.HasACold) == 3 then
                local result = getSpecificPlayer(0):getBodyDamage():getColdSneezeTimerMin() + ZombRand(1, getSpecificPlayer(0):getBodyDamage():getColdSneezeTimerMax() - getSpecificPlayer(0):getBodyDamage():getColdSneezeTimerMin())
                getSpecificPlayer(0):getBodyDamage():setTimeToSneezeOrCough(result);
            elseif getSpecificPlayer(0):getMoodles():getMoodleLevel(MoodleType.HasACold) == 4 then
                local result = getSpecificPlayer(0):getBodyDamage():getNastyColdSneezeTimerMin() + ZombRand(1, getSpecificPlayer(0):getBodyDamage():getNastyColdSneezeTimerMax() - getSpecificPlayer(0):getBodyDamage():getNastyColdSneezeTimerMin())
                getSpecificPlayer(0):getBodyDamage():setTimeToSneezeOrCough(result);
            end
        end
    end
end

local overdoseEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Nasivion.alias] == nil then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Nasivion.alias].isOverdose then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Nasivion.alias].isOverdoseEffectApplied then
        local duration = Nasivion.durationByDosageForm[DosageForm.Intranasal.Drops.alias] / 2 * TimeHandler.durationModifier
        Survivor:getBlood():getDrugs()[Nasivion.alias].duration = Survivor:getBlood():getDrugs()[Nasivion.alias].duration - duration

        Survivor:getBlood():getDrugs()[Nasivion.alias].isOverdoseEffectApplied = true
    end
end

Events.OnTick.Add(normalEffect)
Events.OnTick.Add(overdoseEffect)