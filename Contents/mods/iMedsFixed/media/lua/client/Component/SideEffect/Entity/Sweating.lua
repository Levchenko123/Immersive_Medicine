Sweating = {
    alias = 'Sweating',
    name = getText('UI_SideEffect_Sweating_Name'),
    description = {},
    maxLevel = 2,
    isDurationEnabled = false,
    duration = 0,
    exclusives = {},
}

ZCore:getContainer():register(
    require 'Component/SideEffect/Entity/SideEffect',
    'imeds.side_effect.entity.sweating',
    {
        Sweating,
    },
    'imeds.side_effect.entity'
)

local level = { 16, 41 }
local effect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    local sideEffect = Survivor:getSideEffects()[Sweating.alias]
    if sideEffect == nil then
        return false
    end

    if not sideEffect.isActive then
        return false
    end

    if Survivor:getWetness() < level[sideEffect.level] then
        Survivor:setWetness(level[sideEffect.level])
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'SideEffect' then
        Events.OnTick.Add(effect)
    end
end)