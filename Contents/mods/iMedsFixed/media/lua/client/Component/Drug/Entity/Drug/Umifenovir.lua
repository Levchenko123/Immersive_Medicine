local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class Umifenovir
---200mg/pill
Umifenovir = {
    alias = 'Umifenovir',
    name = getText('UI_Item_Umifenovir_Name'),
    description = getText('UI_Item_Umifenovir_Description'),
    sideEffects = getText('UI_Item_Umifenovir_SideEffects'),
    fullType = 'iMeds.Umifenovir',
    dosageForms = {
        [DosageForm.Oral.Pill.alias] = true,
    },
    durationByDosageForm = {
        [DosageForm.Oral.Pill.alias] = 16 * 60,
    },
    onsetByDosageForm = {
        [DosageForm.Oral.Pill.alias] = 6 * 10,
    },
    singleDose = 1,
    maxDose = 2,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.umifenovir',
    {
        Umifenovir
    },
    'imeds.drug.entity.drug'
)