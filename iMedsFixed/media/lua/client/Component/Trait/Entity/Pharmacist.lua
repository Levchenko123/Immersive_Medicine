Pharmacist = {
    alias = 'Pharmacist',
    name = getText('UI_Trait_Pharmacist_Name'),
    description = getText('UI_Trait_Pharmacist_Description'),
    cost = 4,
    freeRecipes = {},
    xpBoosts = {
        Perks.Doctor,
    },
    xpBoostValues = {
        [Perks.Doctor] = 1,
    },
    mutualExclusives = {
        'Illiterate',
    },
}

ZCore:getContainer():register(
    require 'Component/Trait/Entity/Trait',
    'imeds.trait.entity.pharmacist',
    {
        Pharmacist
    },
    'imeds.trait.entity'
)