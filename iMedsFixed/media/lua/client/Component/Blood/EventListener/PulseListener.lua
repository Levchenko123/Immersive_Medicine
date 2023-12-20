local incrementValue = 0.04
local tachycardiaPulse
local bradycardiaPulse

local updatePulse = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    local endurancePulseModifier
    local panicPulseModifier

    endurancePulseModifier = (1 - Survivor:getEndurance() + 1) / 1
    panicPulseModifier = (Survivor:getPanic() / 100 + 1) / 1

    local modifier = endurancePulseModifier > panicPulseModifier and endurancePulseModifier or panicPulseModifier

    local requestedPulse = Blood.pulse.normal * modifier
    local tachycardia = Survivor:getSideEffects()[Tachycardia.alias]
    if tachycardia ~= nil and tachycardia.isActive then
        requestedPulse = tachycardiaPulse[tachycardia.level] > requestedPulse and tachycardiaPulse[tachycardia.level] or requestedPulse
    end

    local bradycardia = Survivor:getSideEffects()[Bradycardia.alias]
    if bradycardia ~= nil and bradycardia.isActive then
        requestedPulse = bradycardiaPulse[bradycardia.level]
    end

    local pulse = Blood.pulse.normal
    if Survivor:getBlood():getPulse() < requestedPulse then
        pulse = Survivor:getBlood():getPulse() + incrementValue * getGameTime():getMultiplier()
    else
        pulse = Survivor:getBlood():getPulse() - incrementValue * getGameTime():getMultiplier()
    end

    Survivor:getBlood():setPulse(pulse)

    if Survivor:getBlood():getPulse() < Blood.pulse.min then
        Survivor:getBlood():setPulse(Blood.pulse.min)
    end

    if Survivor:getBlood():getPulse() > Blood.pulse.max then
        Survivor:getBlood():setPulse(Blood.pulse.max)
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Blood' then
        tachycardiaPulse = Tachycardia:getPulse()
        bradycardiaPulse = Bradycardia:getPulse()
        Events.OnTick.Add(updatePulse)
    end
end)