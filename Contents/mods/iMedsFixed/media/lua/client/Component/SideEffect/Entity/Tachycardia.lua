Tachycardia = {
    alias = 'Tachycardia',
    name = getText('UI_SideEffect_Tachycardia_Name'),
    description = {
        getText('UI_SideEffect_Tachycardia_Lvl_1_Description'),
        getText('UI_SideEffect_Tachycardia_Lvl_2_Description'),
        getText('UI_SideEffect_Tachycardia_Lvl_3_Description'),
    },
    maxLevel = 3,
    isDurationEnabled = false,
    duration = 0,
    exclusives = {
        'Bradycardia',
    },
}

ZCore:getContainer():register(
    require 'Component/SideEffect/Entity/SideEffect',
    'imeds.side_effect.entity.tachycardia',
    {
        Tachycardia,
    },
    'imeds.side_effect.entity'
)

local pulse = { 85, 110, 150 }

---@return number[]
function Tachycardia:getPulse()
    return pulse
end

local tickSinceLastHeartbeat = 0

local effect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    if not SandboxVars.ImmersiveMedicine.IsHeartbeatEnabled then
        return false
    end

    local sideEffect = Survivor:getSideEffects()[Tachycardia.alias]
    if sideEffect == nil then
        return false
    end

    if not sideEffect.isActive then
        return false
    end

    tickSinceLastHeartbeat = tickSinceLastHeartbeat + 1
    if tickSinceLastHeartbeat > Survivor:getBlood():getHeartbeatDelta(pulse[sideEffect.level]) then
        getSoundManager():playUISound('heart')
        tickSinceLastHeartbeat = 0
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'SideEffect' then
        Events.OnTick.Add(effect)
    end
end)