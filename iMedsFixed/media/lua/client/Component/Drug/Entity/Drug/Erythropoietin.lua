local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class Erythropoietin
---500ME/ml
Erythropoietin = {
    alias = 'Erythropoietin',
    name = getText('UI_Item_Erythropoietin_Name'),
    description = getText('UI_Item_Erythropoietin_Description'),
    sideEffects = getText('UI_Item_Erythropoietin_SideEffects'),
    fullType = 'iMeds.Erythropoietin',
    dosageForms = {
        [DosageForm.Parenteral.Intravenous.alias] = true,
    },
    durationByDosageForm = {
        [DosageForm.Parenteral.Intravenous.alias] = 2 * 60,
    },
    onsetByDosageForm = {
        [DosageForm.Parenteral.Intravenous.alias] = 3 * 60,
    },
    singleDose = 1,
    maxDose = 10,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.erythropoietin',
    {
        Erythropoietin
    },
    'imeds.drug.entity.drug'
)