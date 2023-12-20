ZCore:getContainer():register(
    require 'Component/Moodle/Entity/Moodle',
    'imeds.moodle.entity.opioid_addiction',
    {
        {
            alias = 'OpioidAddiction',
            sideEffect = 'imeds.side_effect.entity.opioid_addiction',
            texture = {
                getTexture('media/ui/Moodles/OpioidAddiction/1.png'),
                getTexture('media/ui/Moodles/OpioidAddiction/2.png'),
                getTexture('media/ui/Moodles/OpioidAddiction/3.png'),
            }
        },
    },
    'imeds.moodle.entity'
)