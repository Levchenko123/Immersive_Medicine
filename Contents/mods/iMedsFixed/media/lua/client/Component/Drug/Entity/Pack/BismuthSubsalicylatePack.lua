BismuthSubsalicylatePack = {
    fullType = 'iMeds.BismuthSubsalicylatePack',
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Pack',
    'imeds.drug.entity.bismuth_subsalicylate_pack',
    {
        BismuthSubsalicylatePack
    },
    'imeds.drug.entity.drug.pack'
)