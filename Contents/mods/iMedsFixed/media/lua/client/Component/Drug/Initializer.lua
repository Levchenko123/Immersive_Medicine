Events.OnGameBoot.Add(
    function()
        local container = ZCore:getContainer()

        container:register(
            require 'Component/Drug/Storage/DrugStorage',
            'imeds.drug.storage.drug_storage',
            {}
        )

        container:register(
            require 'Component/Drug/Storage/OpiateStorage',
            'imeds.drug.storage.opiate_storage',
            {}
        )

        container:register(
            require 'Component/Drug/Storage/DrugPackStorage',
            'imeds.drug.storage.drug_pack_storage',
            {}
        )

        local logger = container:get('imeds.logger.default')
        logger:info('Immersive Medicine Drug component successfully loaded!')
    end
)