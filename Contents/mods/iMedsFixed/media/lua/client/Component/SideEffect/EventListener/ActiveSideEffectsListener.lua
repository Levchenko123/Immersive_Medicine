local removeSideEffect = function()
    if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
        return false
    end

    ---@type SideEffectStorage
    local sideEffectStorage = ZCore:getContainer():get('imeds.side_effect.storage.side_effect_storage')

    for _, sideEffect in pairs(sideEffectStorage:findAll()) do
        Survivor:removeSideEffect(sideEffect:getAlias())
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'SideEffect' then
        Events.OnTick.Add(removeSideEffect)
    end
end)