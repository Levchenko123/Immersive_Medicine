local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class Alkagin
---250mg/ml
Alkagin = {
    alias = 'Alkagin',
    name = getText('UI_Item_Alkagin_Name'),
    description = getText('UI_Item_Alkagin_Description'),
    sideEffects = getText('UI_Item_Alkagin_SideEffects'),
    fullType = 'iMeds.Alkagin',
    dosageForms = {
        [DosageForm.Oral.Liquid.alias] = true,
        [DosageForm.Parenteral.Intramuscular.alias] = true,
    },
    durationByDosageForm = {
        [DosageForm.Oral.Liquid.alias] = 4 * 60,
        [DosageForm.Parenteral.Intramuscular.alias] = 3 * 60,
    },
    onsetByDosageForm = {
        [DosageForm.Oral.Liquid.alias] = 10,
        [DosageForm.Parenteral.Intramuscular.alias] = 10,
    },
    singleDose = 1,
    maxDose = 8,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.alkagin',
    {
        Alkagin
    },
    'imeds.drug.entity.drug'
)