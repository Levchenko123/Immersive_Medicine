local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class Naloxon
---0.4mg/1ml
Naloxon = {
    alias = 'Naloxon',
    name = getText('UI_Item_Naloxon_Name'),
    description = getText('UI_Item_Naloxon_Description'),
    sideEffects = getText('UI_Item_Naloxon_SideEffects'),
    fullType = 'iMeds.Naloxon',
    dosageForms = {
        [DosageForm.Parenteral.Intravenous.alias] = true,
        [DosageForm.Parenteral.Intramuscular.alias] = true,
    },
    durationByDosageForm = {
        [DosageForm.Parenteral.Intravenous.alias] = 1 * 60,
        [DosageForm.Parenteral.Intramuscular.alias] = 2 * 60,
    },
    onsetByDosageForm = {
        [DosageForm.Parenteral.Intravenous.alias] = 0,
        [DosageForm.Parenteral.Intramuscular.alias] = 1 * 10,
    },
    singleDose = 1,
    maxDose = 25,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.naloxon',
    {
        Naloxon
    },
    'imeds.drug.entity.drug'
)