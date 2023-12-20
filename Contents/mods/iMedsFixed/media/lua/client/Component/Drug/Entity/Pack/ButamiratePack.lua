ButamiratePack = {
    fullType = 'iMeds.ButamiratePack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.butamirate_pack',
    {
        ButamiratePack
    },
    'imeds.drug.entity.drug.pack'
)