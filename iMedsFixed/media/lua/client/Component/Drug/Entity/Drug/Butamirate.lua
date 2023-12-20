local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class Butamirate
---1.5mg/ml
Butamirate = {
    alias = 'Butamirate',
    name = getText('UI_Item_Butamirate_Name'),
    description = getText('UI_Item_Butamirate_Description'),
    sideEffects = getText('UI_Item_Butamirate_SideEffects'),
    fullType = 'iMeds.Butamirate',
    dosageForms = {
        [DosageForm.Oral.Liquid.alias] = true,
    },
    durationByDosageForm = {
        [DosageForm.Oral.Liquid.alias] = 6 * 60,
    },
    onsetByDosageForm = {
        [DosageForm.Oral.Liquid.alias] = 4 * 10,
    },
    singleDose = 1,
    maxDose = 3,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.butamirate',
    {
        Butamirate
    },
    'imeds.drug.entity.drug'
)