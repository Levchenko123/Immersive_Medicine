local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class Nasivion
Nasivion = {
    alias = 'Nasivion',
    name = getText('UI_Item_Nasivion_Name'),
    description = getText('UI_Item_Nasivion_Description'),
    sideEffects = getText('UI_Item_Nasivion_SideEffects'),
    fullType = 'iMeds.Nasivion',
    dosageForms = {
        [DosageForm.Intranasal.Drops.alias] = true,
    },
    durationByDosageForm = {
        [DosageForm.Intranasal.Drops.alias] = 4 * 60,
    },
    onsetByDosageForm = {
        [DosageForm.Intranasal.Drops.alias] = 1 * 10,
    },
    singleDose = 1,
    maxDose = 2,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.nasivion',
    {
        Nasivion
    },
    'imeds.drug.entity.drug'
)