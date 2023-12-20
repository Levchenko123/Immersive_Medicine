DonateBloodHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
DonateBloodHandler = BaseHandlerProxy:derive("DonateBloodHandler")

function DonateBloodHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.emptyBloodBag = {}
    public.items.catheter = {}

    return public
end

function DonateBloodHandler:checkItem(item)
    if item:getFullType() == EmptyBloodBag.fullType then
        self:addItem(self.items.emptyBloodBag, item)
    end

    if item:getFullType() == PeripheralVenousCatheter.fullType then
        self:addItem(self.items.catheter, item)
    end
end

function DonateBloodHandler:addToMenu(context)
    if self.bodyPart:getType() == BodyPart.ForeArm_R or self.bodyPart:getType() == BodyPart.ForeArm_L then
        local emptyBloodBagType = self:getAllItemTypes(self.items.emptyBloodBag)
        local catheterType = self:getAllItemTypes(self.items.catheter)

        if #emptyBloodBagType > 0 and #catheterType > 0 then
            local emptyBloodBag = self:getItemOfType(self.items.emptyBloodBag, emptyBloodBagType[1])

            local option = context:addOption(getText("UI_ContextMenu_DonateBlood"), nil)
            local subMenu = context:getNew(context)
            context:addSubMenu(option, subMenu)

            for i = 1, #catheterType do
                local catheter = self:getItemOfType(self.items.catheter, catheterType[i])
                local text = catheter:getName() .. " + " .. emptyBloodBag:getName()
                subMenu:addOption(text, self, self.onMenuOptionSelected, emptyBloodBag:getFullType(), catheter:getFullType())
            end
        end
    end
end

function DonateBloodHandler:dropItems(items)
    if self.bodyPart:getType() == BodyPart.ForeArm_R or self.bodyPart:getType() == BodyPart.ForeArm_L then
        local emptyBloodBagType = self:getAllItemTypes(self.items.emptyBloodBag)
        local catheterType = self:getAllItemTypes(self.items.catheter)

        if #emptyBloodBagType > 0 and #catheterType > 0 then
            self:onMenuOptionSelected(emptyBloodBagType[1], catheterType[1])

            return true
        end
    end

    return false
end

function DonateBloodHandler:isValid(emptyBloodBagType, catheterType)
    self:checkItems()
    local emptyBloodBags = self.items.emptyBloodBag
    local catheters = self.items.catheter

    return #emptyBloodBags > 0 and #catheters > 0
end

function DonateBloodHandler:perform(previousAction, emptyBloodBagType, catheterType)
    if emptyBloodBagType and catheterType then
        local emptyBloodBag = self:getItemOfType(self.items.emptyBloodBag, emptyBloodBagType)
        local catheter = self:getItemOfType(self.items.catheter, catheterType)

        previousAction = self:toPlayerInventory(emptyBloodBag, previousAction)
        previousAction = self:toPlayerInventory(catheter, previousAction)

        local action = DonateBloodAction:new(
            self:getDoctor(),
            self:getPatient(),
            emptyBloodBag,
            catheter,
            self.bodyPart
        )

        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.blood.context_menu.handler.donate_blood_handler',
    {
        DonateBloodHandler
    },
    'imeds.context_menu.health_panel.handler'
)