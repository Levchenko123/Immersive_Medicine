local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class HemoStop
---250mg/ml
HemoStop = {
    alias = 'HemoStop',
    name = getText('UI_Item_HemoStop_Name'),
    description = getText('UI_Item_HemoStop_Description'),
    sideEffects = getText('UI_Item_HemoStop_SideEffects'),
    fullType = 'iMeds.HemoStop',
    dosageForms = {
        [DosageForm.Topical.Powder.alias] = true,
    },
    durationByDosageForm = {},
    onsetByDosageForm = {},
    singleDose = 1,
    maxDose = 9999,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.hemo_stop',
    {
        HemoStop
    },
    'imeds.drug.entity.drug'
)