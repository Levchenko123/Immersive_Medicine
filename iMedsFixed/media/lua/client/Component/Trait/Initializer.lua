Events.OnGameBoot.Add(
    function()
        local container = ZCore:getContainer()

        container:register(
            require 'Component/Trait/Service/Trait/TraitInitializer',
            'imeds.trait.service.trait_initializer',
            {}
        )

        ---@type TraitInitializer
        local traitInitializer = container:get('imeds.trait.service.trait_initializer')
        Events.OnCreateSurvivor.Add(traitInitializer.addTraits(traitInitializer));

        local logger = container:get('imeds.logger.default')
        logger:info('Immersive Medicine Trait component successfully loaded!')
    end
)