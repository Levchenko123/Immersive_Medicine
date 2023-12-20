ZCore:getContainer():register(
    require 'Component/Moodle/Entity/Moodle',
    'imeds.moodle.entity.bradycardia',
    {
        {
            alias = 'Bradycardia',
            sideEffect = 'imeds.side_effect.entity.bradycardia',
            texture = {
                getTexture('media/ui/Moodles/Bradycardia/1.png'),
                getTexture('media/ui/Moodles/Bradycardia/2.png'),
                getTexture('media/ui/Moodles/Bradycardia/3.png'),
            }
        },
    },
    'imeds.moodle.entity'
)