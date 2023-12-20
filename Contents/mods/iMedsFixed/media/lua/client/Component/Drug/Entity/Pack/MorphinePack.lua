MorphinePack = {
    fullType = 'iMeds.MorphinePack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.morphine_pack',
    {
        MorphinePack
    },
    'imeds.drug.entity.drug.pack'
)