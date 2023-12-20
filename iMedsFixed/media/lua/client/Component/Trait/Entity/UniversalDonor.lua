UniversalDonor = {
    alias = 'UniversalDonor',
    name = getText('UI_Trait_UniversalDonor_Name'),
    description = getText('UI_Trait_UniversalDonor_Description'),
    cost = 1,
    freeRecipes = {},
    xpBoosts = {},
    xpBoostValues = {},
    mutualExclusives = {
        'UniversalRecipient',
    },
}

ZCore:getContainer():register(
    require 'Component/Trait/Entity/Trait',
    'imeds.trait.entity.universal_donor',
    {
        UniversalDonor
    },
    'imeds.trait.entity'
)