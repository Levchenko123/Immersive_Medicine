local DosageForm = require 'Component/Drug/Entity/DosageForm'

---@class BismuthSubsalicylate
---250mg/pill
BismuthSubsalicylate = {
    alias = 'BismuthSubsalicylate',
    name = getText('UI_Item_BismuthSubsalicylate_Name'),
    description = getText('UI_Item_BismuthSubsalicylate_Description'),
    sideEffects = getText('UI_Item_BismuthSubsalicylate_SideEffects'),
    fullType = 'iMeds.BismuthSubsalicylate',
    dosageForms = {
        [DosageForm.Oral.Pill.alias] = true,
    },
    durationByDosageForm = {
        [DosageForm.Oral.Pill.alias] = 2 * 60,
    },
    onsetByDosageForm = {
        [DosageForm.Oral.Pill.alias] = 10,
    },
    singleDose = 1,
    maxDose = 8,
}

ZCore:getContainer():register(
    require 'Component/Drug/Entity/Drug',
    'imeds.drug.entity.bismuth_subsalicylate',
    {
        BismuthSubsalicylate
    },
    'imeds.drug.entity.drug'
)