Events.OnGameBoot.Add(
    function()
        local container = ZCore:getContainer()

        container:register(
            require 'Component/Blood/Storage/BloodGroupStorage',
            'imeds.blood.storage.blood_group_storage',
            {}
        )

        local logger = container:get('imeds.logger.default')
        logger:info('Immersive Medicine Blood component successfully loaded!')
    end
)