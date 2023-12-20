TakeDrugsParenteralHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
TakeDrugsParenteralHandler = BaseHandlerProxy:derive("TakeDrugsParenteralHandler")

function TakeDrugsParenteralHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.syringe = {}

    return public
end

function TakeDrugsParenteralHandler:checkItem(item)
    if item:getModData().syringe ~= nil
        and item:getModData().syringe.drug ~= nil
        and item:getModData().syringe.drug.dosageForms ~= nil
    then
        for dosageForm, _ in pairs(item:getModData().syringe.drug.dosageForms) do
            if DosageForm.Parenteral[dosageForm] ~= nil and not in_table(item, self.items.syringe) then
                self:addItem(self.items.syringe, item)
            end
        end
    end
end

function TakeDrugsParenteralHandler:addToMenu(context)
    if not in_table(
        self.bodyPart:getType(),
        {
            BodyPart.ForeArm_L,
            BodyPart.ForeArm_R,
            BodyPart.UpperArm_L,
            BodyPart.UpperArm_R,
            BodyPart.Torso_Lower,
            BodyPart.Torso_Upper,
            BodyPart.UpperLeg_L,
            BodyPart.UpperLeg_R,
            BodyPart.LowerLeg_L,
            BodyPart.LowerLeg_R,
        }
    ) then
        return false
    end

    local syringes = self.items.syringe
    if #syringes > 0 then
        local options = {}
        for alias, data in pairs(DosageForm.Parenteral) do
            local itemMenu = context:getNew(context)
            for i = 1, #syringes do
                local syringe = self.items.syringe[i]
                if syringe:getModData().syringe.drug.dosageForms[alias] ~= nil then
                    if options[alias] == nil then
                        options[alias] = context:addOption(data.action, nil)
                    end

                    context:addSubMenu(options[alias], itemMenu)
                    local itemMenuOption = itemMenu:addOption(syringe:getName(), nil)
                    local dosageMenu = context:getNew(context)
                    context:addSubMenu(itemMenuOption, dosageMenu)

                    for dosage = 1, round(syringe:getDrainableUsesFloat()) do
                        local text = string.format('%s %s', dosage, getText('UI_ContextMenu_Ml'))
                        dosageMenu:addOption(text, self, self.onMenuOptionSelected, syringe, alias, dosage)
                    end
                end
            end
        end
    end
end

function TakeDrugsParenteralHandler:dropItems(items)
    if not in_table(
        self.bodyPart:getType(),
        {
            BodyPart.ForeArm_L,
            BodyPart.ForeArm_R,
            BodyPart.UpperArm_L,
            BodyPart.UpperArm_R,
            BodyPart.Torso_Lower,
            BodyPart.Torso_Upper,
            BodyPart.UpperLeg_L,
            BodyPart.UpperLeg_R,
            BodyPart.LowerLeg_L,
            BodyPart.LowerLeg_R,
        }
    ) then
        return false
    end

    if tableLength(self.items.syringe) > 0 then
        self:onMenuOptionSelected(self.items.syringe[1])

        return true
    end

    return false
end

function TakeDrugsParenteralHandler:isValid(syringe, dosageForm, dosage)
    self:checkItems()
    local syringes = self.items.syringe

    return #syringes > 0 and DosageForm.Parenteral[dosageForm] ~= nil
end

function TakeDrugsParenteralHandler:perform(previousAction, syringe, dosageForm, dosage)
    if syringe then
        previousAction = self:toPlayerInventory(syringe, previousAction)

        local action = TakeDrugsParenteralAction:new(self:getDoctor(), self:getPatient(), syringe, self.bodyPart, dosageForm, dosage)
        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.take_drugs_parenteral_handler',
    {
        TakeDrugsParenteralHandler
    },
    'imeds.context_menu.health_panel.handler'
)