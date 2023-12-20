HemoStopHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
HemoStopHandler = BaseHandlerProxy:derive("HemoStopHandler")

function HemoStopHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.drug = {}

    return public
end

function HemoStopHandler:checkItem(item)
    if item:getModData().drug ~= nil
        and item:getModData().drug ~= nil
        and item:getModData().drug.dosageForms ~= nil
        and item:getModData().drug.dosageForms[DosageForm.Topical.Powder.alias] ~= nil
        and item:getFullType() == HemoStop.fullType
        and not in_table(item, self.items.drug)
    then
        self:addItem(self.items.drug, item)
    end
end

function HemoStopHandler:addToMenu(context)
    if not self.bodyPart:bleeding() or self.bodyPart:getBleedingTime() == 0 then
        return false
    end

    local dosage = 5
    if self.bodyPart:scratched() then
        dosage = 5
    elseif self.bodyPart:isCut() then
        dosage = 10
    elseif self.bodyPart:bitten() then
        dosage = 10
    elseif self.bodyPart:isDeepWounded() then
        dosage = 10
    elseif self.bodyPart:haveGlass() then
        dosage = 10
    elseif self.bodyPart:haveBullet() then
        dosage = 10
    end

    local drugs = self.items.drug
    if #drugs > 0 then
        for alias, data in pairs(DosageForm.Topical) do
            local dosageFormOption = context:addOption(data.action, nil)
            local itemMenu = context:getNew(context)
            for i = 1, #drugs do
                local drug = self.items.drug[i]
                if round(drug:getDrainableUsesFloat()) >= dosage and drug:getModData().drug.dosageForms[alias] ~= nil then
                    context:addSubMenu(dosageFormOption, itemMenu)
                    itemMenu:addOption(drug:getName(), self, self.onMenuOptionSelected, drug, alias, dosage)
                end
            end
        end
    end
end

function HemoStopHandler:dropItems(items)
    if not self.bodyPart:bleeding() or self.bodyPart:getBleedingTime() == 0 then
        return false
    end

    if tableLength(self.items.drug) > 0 then
        self:onMenuOptionSelected(self.items.drug[1])

        return true
    end

    return false
end

function HemoStopHandler:isValid(drug, dosageForm, dosage)
    self:checkItems()
    local drugs = self.items.drug

    return #drugs > 0 and round(drug:getDrainableUsesFloat()) >= dosage and DosageForm.Topical[dosageForm] ~= nil
end

function HemoStopHandler:perform(previousAction, drug, dosageForm, dosage)
    if drug then
        previousAction = self:toPlayerInventory(drug, previousAction)

        local action = HemoStopAction:new(self:getDoctor(), self:getPatient(), drug, self.bodyPart, dosageForm, dosage)
        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.hemo_stop_handler',
    {
        HemoStopHandler
    },
    'imeds.context_menu.health_panel.handler'
)