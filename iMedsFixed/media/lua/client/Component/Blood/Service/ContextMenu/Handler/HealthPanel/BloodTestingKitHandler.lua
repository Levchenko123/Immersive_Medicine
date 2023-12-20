BloodTestingKitHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
BloodTestingKitHandler = BaseHandlerProxy:derive("BloodTestingKitHandler")

function BloodTestingKitHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.kit = {}

    return public
end

function BloodTestingKitHandler:checkItem(item)
    if item:getFullType() == BloodTestingKit.fullType and item:getDrainableUsesInt() == 1 then
        self:addItem(self.items.kit, item)
    end
end

function BloodTestingKitHandler:addToMenu(context)
    local kitType = self:getAllItemTypes(self.items.kit)

    if #kitType > 0 then
        local kit = self:getItemOfType(self.items.kit, kitType[1])
        context:addOption(getText("UI_ContextMenu_TestBlood"), self, self.onMenuOptionSelected, kit:getFullType())
    end
end

function BloodTestingKitHandler:dropItems(items)
    local kitType = self:getAllItemTypes(self.items.kit)

    if #kitType > 0 then
        self:onMenuOptionSelected(kitType[1])

        return true
    end

    return false
end

function BloodTestingKitHandler:isValid(kitType)
    self:checkItems()
    local kits = self.items.kit

    return #kits > 0
end

function BloodTestingKitHandler:perform(previousAction, kitType)
    if kitType then
        local kit = self:getItemOfType(self.items.kit, kitType)
        previousAction = self:toPlayerInventory(kit, previousAction)

        local action = BloodTestingKitAction:new(self:getDoctor(), self:getPatient(), kit, self.bodyPart)
        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.blood.context_menu.handler.blood_testing_kit_handler',
    {
        BloodTestingKitHandler
    },
    'imeds.context_menu.health_panel.handler'
)