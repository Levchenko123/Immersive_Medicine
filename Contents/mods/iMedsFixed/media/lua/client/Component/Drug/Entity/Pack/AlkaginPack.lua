AlkaginPack = {
    fullType = 'iMeds.AlkaginPack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.alkagin_pack',
    {
        AlkaginPack
    },
    'imeds.drug.entity.drug.pack'
)