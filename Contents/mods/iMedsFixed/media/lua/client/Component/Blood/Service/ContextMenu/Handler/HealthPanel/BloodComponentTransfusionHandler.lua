BloodComponentTransfusionHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
BloodComponentTransfusionHandler = BaseHandlerProxy:derive("BloodComponentTransfusionHandler")

function BloodComponentTransfusionHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.erythrocyteSuspensionBag = {}
    public.items.plasmaBag = {}
    public.items.catheter = {}

    return public
end

function BloodComponentTransfusionHandler:checkItem(item)
    if ErythrocyteSuspensionBag:haveFullType(item:getFullType()) and not in_table(item, self.items.erythrocyteSuspensionBag) then
        self:addItem(self.items.erythrocyteSuspensionBag, item)
    end

    if PlasmaBag:haveFullType(item:getFullType()) and not in_table(item, self.items.plasmaBag) then
        self:addItem(self.items.plasmaBag, item)
    end

    if item:getFullType() == PeripheralVenousCatheter.fullType then
        self:addItem(self.items.catheter, item)
    end
end

function BloodComponentTransfusionHandler:addToMenu(context)
    if self.bodyPart:getType() == BodyPart.ForeArm_R or self.bodyPart:getType() == BodyPart.ForeArm_L then
        local erythrocyteSuspensionBags = self.items.erythrocyteSuspensionBag
        local plasmaBags = self.items.plasmaBag
        local catheterType = self:getAllItemTypes(self.items.catheter)

        if #erythrocyteSuspensionBags > 0 and #plasmaBags > 0 and #catheterType > 0 then
            local option = context:addOption(getText("UI_ContextMenu_TransferBlood"), nil)
            local subMenu = context:getNew(context)
            context:addSubMenu(option, subMenu)

            for i = 1, #erythrocyteSuspensionBags do
                local erythrocyteSuspensionBag = self.items.erythrocyteSuspensionBag[i]
                local erythrocyteSuspensionType = ErythrocyteSuspensionBag:getBloodTypeByFullType(erythrocyteSuspensionBag:getFullType())

                local plasmaBag
                for j = 1, #plasmaBags do
                    if PlasmaBag:getBloodTypeByFullType(self.items.plasmaBag[j]:getFullType()) == erythrocyteSuspensionType then
                        plasmaBag = self.items.plasmaBag[j]
                        break
                    end
                end

                if plasmaBag ~= nil then
                    local catheter = self:getItemOfType(self.items.catheter, catheterType[1])
                    local text = erythrocyteSuspensionBag:getName() .. ' + ' .. plasmaBag:getName()

                    subMenu:addOption(text, self, self.onMenuOptionSelected, erythrocyteSuspensionBag, plasmaBag, catheter:getFullType())
                end
            end
        end
    end
end

function BloodComponentTransfusionHandler:dropItems(items)
    return false
end

function BloodComponentTransfusionHandler:isValid(erythrocyteSuspensionBag, plasmaBag, catheterType)
    self:checkItems()
    local erythrocyteSuspensionBags = self.items.erythrocyteSuspensionBag
    local plasmaBags = self.items.plasmaBag
    local catheters = self.items.catheter

    return #erythrocyteSuspensionBags > 0 and #catheters > 0 and #plasmaBags > 0
end

function BloodComponentTransfusionHandler:perform(previousAction, erythrocyteSuspensionBag, plasmaBag, catheterType)
    if erythrocyteSuspensionBag and plasmaBag and catheterType then
        local catheter = self:getItemOfType(self.items.catheter, catheterType)

        previousAction = self:toPlayerInventory(erythrocyteSuspensionBag, previousAction)
        previousAction = self:toPlayerInventory(plasmaBag, previousAction)
        previousAction = self:toPlayerInventory(catheter, previousAction)

        local action = BloodComponentTransfusionAction:new(self:getDoctor(), self:getPatient(), erythrocyteSuspensionBag, plasmaBag, catheter, self.bodyPart)

        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.blood.context_menu.handler.blood_component_transfusion',
    {
        BloodComponentTransfusionHandler
    },
    'imeds.context_menu.health_panel.handler'
)