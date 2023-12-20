ErythropoietinPack = {
    fullType = 'iMeds.ErythropoietinPack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.erythropoietin_pack',
    {
        ErythropoietinPack
    },
    'imeds.drug.entity.drug.pack'
)