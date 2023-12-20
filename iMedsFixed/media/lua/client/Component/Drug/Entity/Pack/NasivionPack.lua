NasivionPack = {
    fullType = 'iMeds.NasivionPack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.nasivion_pack',
    {
        NasivionPack
    },
    'imeds.drug.entity.drug.pack'
)