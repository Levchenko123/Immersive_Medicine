local incrementValue = 0.04
local bloodPressurePenaltyModifiers = { 0.9, 0.75, 0.5, 0.3 }

local updateBloodPressure = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    local systolicPressure = BloodPressure.systolic.normal
    local diastolicPressure = BloodPressure.diastolic.normal

    local enduranceBloodPressureModifier
    local panicBloodPressureModifier

    enduranceBloodPressureModifier = (1 - Survivor:getEndurance() + 2) / 2
    panicBloodPressureModifier = (Survivor:getPanic() / 100 + 2) / 2

    local  requestedBloodPressureModifier = enduranceBloodPressureModifier > panicBloodPressureModifier and enduranceBloodPressureModifier or panicBloodPressureModifier

    local bloodLoss = Blood.maxVolume - Survivor:getBlood():getVolume()
    if bloodLoss > 250 and bloodLoss <= 1000 then
        requestedBloodPressureModifier = requestedBloodPressureModifier * bloodPressurePenaltyModifiers[1]
    elseif bloodLoss > 1000 and bloodLoss <= 2000 then
        requestedBloodPressureModifier = requestedBloodPressureModifier * bloodPressurePenaltyModifiers[2]
    elseif bloodLoss > 2000 and bloodLoss <= 3500 then
        requestedBloodPressureModifier = requestedBloodPressureModifier * bloodPressurePenaltyModifiers[3]
    elseif bloodLoss > 3500 and bloodLoss <= 3600 then
        requestedBloodPressureModifier = requestedBloodPressureModifier * bloodPressurePenaltyModifiers[4]
    end

    local requestedSystolicBloodPressure = BloodPressure.systolic.normal * requestedBloodPressureModifier
    local requestedDiastolicBloodPressure = BloodPressure.diastolic.normal * requestedBloodPressureModifier

    if Survivor:getBlood():getPressure():getSystolic() < requestedSystolicBloodPressure then
        systolicPressure = Survivor:getBlood():getPressure():getSystolic() + incrementValue * getGameTime():getMultiplier()
    else
        systolicPressure = Survivor:getBlood():getPressure():getSystolic() - incrementValue * getGameTime():getMultiplier()
    end

    Survivor:getBlood():getPressure():setSystolic(systolicPressure)

    if Survivor:getBlood():getPressure():getDiastolic() < requestedDiastolicBloodPressure then
        diastolicPressure = Survivor:getBlood():getPressure():getDiastolic() + incrementValue * getGameTime():getMultiplier()
    else
        diastolicPressure = Survivor:getBlood():getPressure():getDiastolic() - incrementValue * getGameTime():getMultiplier()
    end

    Survivor:getBlood():getPressure():setDiastolic(diastolicPressure)

    if Survivor:getBlood():getPressure():getSystolic() < BloodPressure.systolic.min then
        Survivor:getBlood():getPressure():setSystolic(BloodPressure.systolic.min)
    end

    if Survivor:getBlood():getPressure():getSystolic() > BloodPressure.systolic.max then
        Survivor:getBlood():getPressure():setSystolic(BloodPressure.systolic.max)
    end

    if Survivor:getBlood():getPressure():getDiastolic() < BloodPressure.diastolic.min then
        Survivor:getBlood():getPressure():setDiastolic(BloodPressure.diastolic.min)
    end

    if Survivor:getBlood():getPressure():getDiastolic() > BloodPressure.diastolic.max then
        Survivor:getBlood():getPressure():setDiastolic(BloodPressure.diastolic.max)
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Blood' then
        Events.OnTick.Add(updateBloodPressure)
    end
end)