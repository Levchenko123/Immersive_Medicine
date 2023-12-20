local normalEffect = function()
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Butamirate.alias] == nil then
        return false
    end

    if Survivor:getBlood():getDrugs()[Butamirate.alias].isActive then
        if not getSpecificPlayer(0):getBodyDamage():isHasACold() then
            return false
        end

        --- 1 - sneeze
        --- 2 - cough
        --- 3 - tissue sneeze
        --- 4 - tissue cough
        if getSpecificPlayer(0):getBodyDamage():getTimeToSneezeOrCough() <= 1 then
            getSpecificPlayer(0):getBodyDamage():setSneezeCoughActive(1)

            if getSpecificPlayer(0):hasEquipped('Tissue') then
                getSpecificPlayer(0):getBodyDamage():setSneezeCoughActive(3)
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
    if not Survivor:isInitialized() or Survivor:getBlood():getDrugs()[Butamirate.alias] == nil then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Butamirate.alias].isOverdose then
        return false
    end

    if not Survivor:getBlood():getDrugs()[Butamirate.alias].isOverdoseEffectApplied then
        local duration = Butamirate.durationByDosageForm[DosageForm.Liquid.Pill] / 2
        Survivor:getBlood():getDrugs()[Butamirate.alias].duration = Survivor:getBlood():getDrugs()[Butamirate.alias].duration - duration
    end
end

Events.OnTick.Add(normalEffect)
Events.OnTick.Add(overdoseEffect)