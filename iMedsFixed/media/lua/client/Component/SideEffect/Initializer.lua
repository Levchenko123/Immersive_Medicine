Events.OnGameBoot.Add(
    function()
        local container = ZCore:getContainer()

        container:register(
            require 'Component/SideEffect/Storage/SideEffectStorage',
            'imeds.side_effect.storage.side_effect_storage',
            {}
        )

        local logger = container:get('imeds.logger.default')
        logger:info('Immersive Medicine SideEffect component successfully loaded!')
    end
)