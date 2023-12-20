ZCore:getContainer():register(
    require 'Component/Moodle/Entity/Moodle',
    'imeds.moodle.entity.visual_impairment',
    {
        {
            alias = 'VisualImpairment',
            sideEffect = 'imeds.side_effect.entity.visual_impairment',
            texture = {
                getTexture('media/ui/Moodles/VisualImpairment/1.png'),
            }
        },
    },
    'imeds.moodle.entity'
)