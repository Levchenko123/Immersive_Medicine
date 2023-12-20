local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class Morphine
---10mg/ml
Morphine = {
    alias = 'Morphine',
    name = getText('UI_Item_Morphine_Name'),
    description = getText('UI_Item_Morphine_Description'),
    sideEffects = getText('UI_Item_Morphine_SideEffects'),
    fullType = 'iMeds.Morphine',
    dosageForms = {
        [DosageForm.Oral.Liquid.alias] = true,
        [DosageForm.Parenteral.Intravenous.alias] = true,
        [DosageForm.Parenteral.Intramuscular.alias] = true,
    },
    durationByDosageForm = {
        [DosageForm.Oral.Liquid.alias] = 60,
        [DosageForm.Parenteral.Intravenous.alias] = 5 * 60,
        [DosageForm.Parenteral.Intramuscular.alias] = 6 * 60,
    },
    onsetByDosageForm = {
        [DosageForm.Oral.Liquid.alias] = 2 * 10,
        [DosageForm.Parenteral.Intravenous.alias] = 10,
        [DosageForm.Parenteral.Intramuscular.alias] = 2 * 10,
    },
    singleDose = 1,
    maxDose = 3,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.morphine',
    {
        Morphine
    },
    'imeds.drug.entity.drug'
)

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.opiate.morphine',
    {
        Morphine
    },
    'imeds.drug.entity.drug.opiate'
)