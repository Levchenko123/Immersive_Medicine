UmifenovirPack = {
    fullType = 'iMeds.UmifenovirPack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.umifenovir_pack',
    {
        UmifenovirPack
    },
    'imeds.drug.entity.drug.pack'
)