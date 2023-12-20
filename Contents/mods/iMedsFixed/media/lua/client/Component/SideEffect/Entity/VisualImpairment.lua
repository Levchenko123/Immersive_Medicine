VisualImpairment = {
    alias = 'VisualImpairment',
    name = getText('UI_SideEffect_VisualImpairment_Name'),
    description = {
        getText('UI_SideEffect_VisualImpairment_Lvl_1_Description'),
    },
    maxLevel = 1,
    isDurationEnabled = false,
    duration = 0,
    exclusives = {},
}

ZCore:getContainer():register(
    require 'Component/SideEffect/Entity/SideEffect',
    'imeds.side_effect.entity.visual_impairment',
    {
        VisualImpairment,
    },
    'imeds.side_effect.entity'
)

local effect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    local sideEffect = Survivor:getSideEffects()[VisualImpairment.alias]
    if sideEffect == nil then
        return false
    end

    if not sideEffect.isActive then
        return false
    end

    if (getCore():getZoom(0) > 0.25) then
        getCore():doZoomScroll(getSpecificPlayer(0):getPlayerNum(), -1)
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'SideEffect' then
        Events.OnTick.Add(effect)
    end
end)

