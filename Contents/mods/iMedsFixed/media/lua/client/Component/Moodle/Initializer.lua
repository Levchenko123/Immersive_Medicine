Events.OnGameBoot.Add(
    function()
        local container = ZCore:getContainer()

        container:register(
            require 'Component/Moodle/Storage/MoodleStorage',
            'imeds.moodle.storage.moodle_storage',
            {}
        )

        local logger = container:get('imeds.logger.default')
        logger:info('Immersive Medicine Moodle component successfully loaded!')
    end
)