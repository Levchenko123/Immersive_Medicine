ZCore:getContainer():register(
    require 'Component/Moodle/Entity/Moodle',
    'imeds.moodle.entity.tachycardia',
    {
        {
            alias = 'Tachycardia',
            sideEffect = 'imeds.side_effect.entity.tachycardia',
            texture = {
                getTexture('media/ui/Moodles/Tachycardia/1.png'),
                getTexture('media/ui/Moodles/Tachycardia/2.png'),
                getTexture('media/ui/Moodles/Tachycardia/3.png'),
            }
        },
    },
    'imeds.moodle.entity'
)