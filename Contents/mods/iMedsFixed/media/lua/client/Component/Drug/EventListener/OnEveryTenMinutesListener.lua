local updateSurvivorDrugsEffect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    for drugAlias, drugData in pairs(Survivor:getBlood():getDrugs()) do
        if type(drugData) == 'table' then
            if drugData.dose <= drugData.maxDose then
                Survivor:getBlood():getDrugs()[drugAlias].isOverdose = false
            end

            if drugData.dose > drugData.maxDose then
                Survivor:getBlood():getDrugs()[drugAlias].isOverdose = true
                Survivor:getBlood():getDrugs()[drugAlias].isOverdoseEffectsApplied = false
                Survivor:getBlood():getDrugs()[drugAlias].dose = drugData.maxDose
            end

            if drugData.dose >= 1 then
                if drugData.onset > 0 and drugData.duration > 0 then
                    Survivor:getBlood():getDrugs()[drugAlias].onset = Survivor:getBlood():getDrugs()[drugAlias].onset - 10
                end

                if drugData.onset == 0 and drugData.duration > 0 then
                    Survivor:getBlood():getDrugs()[drugAlias].duration = Survivor:getBlood():getDrugs()[drugAlias].duration - 10
                    Survivor:getBlood():getDrugs()[drugAlias].isActive = true
                end

                if drugData.onset == 0 and drugData.duration == 0 then
                    Survivor:getBlood():getDrugs()[drugAlias].isActive = false
                    Survivor:getBlood():getDrugs()[drugAlias].isOverdose = false
                    Survivor:getBlood():getDrugs()[drugAlias].isOverdoseEffectsApplied = false
                    Survivor:getBlood():getDrugs()[drugAlias].dose = 0
                end
            end

            if drugData.dose < 0 then
                Survivor:getBlood():getDrugs()[drugAlias].dose = 0
            end
        end
    end

end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Drug' then
        Events.EveryTenMinutes.Add(updateSurvivorDrugsEffect)
    end
end)

