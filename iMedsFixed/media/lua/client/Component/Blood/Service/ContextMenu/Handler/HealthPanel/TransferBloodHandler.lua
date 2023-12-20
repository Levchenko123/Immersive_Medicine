TransferBloodHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
TransferBloodHandler = BaseHandlerProxy:derive("TransferBloodHandler")

function TransferBloodHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.fullBloodBag = {}
    public.items.catheter = {}

    return public
end

function TransferBloodHandler:checkItem(item)
    if item:getFullType() == FullBloodBag.fullType and not in_table(item, self.items.fullBloodBag) then
        self:addItem(self.items.fullBloodBag, item)
    end

    if item:getFullType() == PeripheralVenousCatheter.fullType then
        self:addItem(self.items.catheter, item)
    end
end

function TransferBloodHandler:addToMenu(context)
    if self.bodyPart:getType() == BodyPart.ForeArm_R or self.bodyPart:getType() == BodyPart.ForeArm_L then
        local fullBloodBags = self.items.fullBloodBag
        local catheterType = self:getAllItemTypes(self.items.catheter)

        if #fullBloodBags > 0 and #catheterType > 0 then
            local option = context:addOption(getText("UI_ContextMenu_TransferBlood"), nil)
            local subMenu = context:getNew(context)
            context:addSubMenu(option, subMenu)

            for i = 1, #fullBloodBags do
                local fullBloodBag = self.items.fullBloodBag[i]
                local catheter = self:getItemOfType(self.items.catheter, catheterType[1])
                subMenu:addOption(fullBloodBag:getName(), self, self.onMenuOptionSelected, fullBloodBag, catheter:getFullType())
            end
        end
    end
end

function TransferBloodHandler:dropItems(items)
    if self.bodyPart:getType() == BodyPart.ForeArm_R or self.bodyPart:getType() == BodyPart.ForeArm_L then
        local fullBloodBagType = self:getAllItemTypes(self.items.fullBloodBag)
        local catheterType = self:getAllItemTypes(self.items.catheter)

        if #fullBloodBagType > 0 and #catheterType > 0 then
            self:onMenuOptionSelected(fullBloodBagType[1], catheterType[1])

            return true
        end
    end

    return false
end

function TransferBloodHandler:isValid(fullBloodBag, catheterType)
    self:checkItems()
    local fullBloodBags = self.items.fullBloodBag
    local catheters = self.items.catheter

    return #fullBloodBags > 0 and #catheters > 0
end

function TransferBloodHandler:perform(previousAction, fullBloodBag, catheterType)
    if fullBloodBag and catheterType then
        local catheter = self:getItemOfType(self.items.catheter, catheterType)

        previousAction = self:toPlayerInventory(fullBloodBag, previousAction)
        previousAction = self:toPlayerInventory(catheter, previousAction)

        local action = TransferBloodAction:new(self:getDoctor(), self:getPatient(), fullBloodBag, catheter, self.bodyPart)

        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.blood.context_menu.handler.transfer_blood_handler',
    {
        TransferBloodHandler
    },
    'imeds.context_menu.health_panel.handler'
)