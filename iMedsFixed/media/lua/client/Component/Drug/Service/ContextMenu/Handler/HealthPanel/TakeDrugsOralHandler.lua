TakeDrugsOralHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
TakeDrugsOralHandler = BaseHandlerProxy:derive("TakeDrugsOralHandler")

function TakeDrugsOralHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.drug = {}

    return public
end

function TakeDrugsOralHandler:checkItem(item)
    if item:getModData().drug ~= nil and item:getModData().drug.dosageForms ~= nil then
        for dosageForm, _ in pairs(item:getModData().drug.dosageForms) do
            if DosageForm.Oral[dosageForm] ~= nil and not in_table(item, self.items.drug) then
                self:addItem(self.items.drug, item)
            end
        end
    end
end

function TakeDrugsOralHandler:addToMenu(context)
    if self.bodyPart:getType() ~= BodyPart.Head then
        return false
    end

    local drugs = self.items.drug
    if #drugs > 0 then
        local options = {}
        for alias, data in pairs(DosageForm.Oral) do
            local itemMenu = context:getNew(context)
            for i = 1, #drugs do
                local drug = self.items.drug[i]
                if drug:getModData().drug.dosageForms[alias] ~= nil then
                    if options[alias] == nil then
                        options[alias] = context:addOption(data.action, nil)
                    end

                    context:addSubMenu(options[alias], itemMenu)
                    itemMenu:addOption(drug:getName(), self, self.onMenuOptionSelected, drug, alias)
                end
            end
        end
    end
end

function TakeDrugsOralHandler:dropItems(items)
    if self.bodyPart:getType() ~= BodyPart.Head then
        return false
    end

    local drugs = self.items.drug
    if #drugs > 0 then
        self:onMenuOptionSelected(drugs[1])

        return true
    end

    return false
end

function TakeDrugsOralHandler:isValid(drug, dosageForm)
    self:checkItems()
    local drugs = self.items.drug

    return #drugs > 0 and DosageForm.Oral[dosageForm] ~= nil
end

function TakeDrugsOralHandler:perform(previousAction, drug, dosageForm)
    if drug then
        previousAction = self:toPlayerInventory(drug, previousAction)

        local action = TakeDrugsOralAction:new(self:getDoctor(), self:getPatient(), drug, self.bodyPart, dosageForm)
        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.take_drugs_oral_handler',
    {
        TakeDrugsOralHandler
    },
    'imeds.context_menu.health_panel.handler'
)