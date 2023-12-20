local isInitialized = false
local initializeSurvivor = function()
    if Survivor:isDeadOrNotExist() then
        return false
    end

    if not Survivor:isInitialized() then
        local container = ZCore:getContainer()
        ---@type SurvivorCreator
        local survivorCreator = container:get('imeds.survivor.service.survivor_creator')
        survivorCreator:create()

        Survivor:setIsInitialized(true)

        local logger = container:get('imeds.logger.default')
        logger:info('Survivor successfully created')
    end

    if not isInitialized then
        triggerEvent(ImmersiveMedicineEvent.iMedsSurvivorCreated, 'Drug');
        triggerEvent(ImmersiveMedicineEvent.iMedsSurvivorCreated, 'Moodle');
        triggerEvent(ImmersiveMedicineEvent.iMedsSurvivorCreated, 'SideEffect');
        triggerEvent(ImmersiveMedicineEvent.iMedsSurvivorCreated, 'Trait');
        triggerEvent(ImmersiveMedicineEvent.iMedsSurvivorCreated, 'Blood');
        isInitialized = true
    end
end

Events.OnPlayerDeath.Add(function() isInitialized = false end)
Events.OnGameStart.Add(initializeSurvivor)
Events.OnCreatePlayer.Add(initializeSurvivor)