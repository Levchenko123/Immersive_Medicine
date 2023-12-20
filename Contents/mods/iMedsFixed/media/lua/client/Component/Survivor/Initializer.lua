Events.OnGameBoot.Add(
    function()
        local container = ZCore:getContainer()

        container:register(
            require 'Component/Survivor/Service/Survivor/SurvivorCreator',
            'imeds.survivor.service.survivor_creator',
            {
                ZCore:getContainer():get('imeds.blood.storage.blood_group_storage')
            }
        )

        local logger = container:get('imeds.logger.default')
        logger:info('Immersive Medicine Survivor component successfully loaded!')
    end
)