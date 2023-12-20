UniversalRecipient = {
    alias = 'UniversalRecipient',
    name = getText('UI_Trait_UniversalRecipient_Name'),
    description = getText('UI_Trait_UniversalRecipient_Description'),
    cost = 3,
    freeRecipes = {},
    xpBoosts = {},
    xpBoostValues = {},
    mutualExclusives = {},
}

ZCore:getContainer():register(
    require 'Component/Trait/Entity/Trait',
    'imeds.trait.entity.universal_recipient',
    {
        UniversalRecipient
    },
    'imeds.trait.entity'
)