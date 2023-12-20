CheckBloodPressureHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
CheckBloodPressureHandler = BaseHandlerProxy:derive("CheckBloodPressureHandler")

function CheckBloodPressureHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.tonometers = {}

    return public
end

function CheckBloodPressureHandler:checkItem(item)
    if in_table(item:getFullType(), { BloodPressureMonitorLeft.fullType, BloodPressureMonitorRight.fullType }) then
        self:addItem(self.items.tonometers, item)
    end
end

function CheckBloodPressureHandler:addToMenu(context)
    if in_table(self.bodyPart:getType(), { BodyPart.UpperArm_R, BodyPart.UpperArm_L }) then
        local tonometerTypes = self:getAllItemTypes(self.items.tonometers)

        if #tonometerTypes > 0 then
            local tonometer = self:getItemOfType(self.items.tonometers, tonometerTypes[1])
            context:addOption(getText("UI_ContextMenu_CheckBloodPressure"), self, self.onMenuOptionSelected, tonometer:getFullType())
        end
    end
end

function CheckBloodPressureHandler:dropItems(items)
    if in_table(self.bodyPart:getType(), { BodyPart.UpperArm_R, BodyPart.UpperArm_L }) then
        local tonometerTypes = self:getAllItemTypes(self.items.tonometers)

        if #tonometerTypes > 0 then
            self:onMenuOptionSelected(tonometerTypes[1])

            return true
        end
    end

    return false
end

function CheckBloodPressureHandler:isValid(tonometerType)
    self:checkItems()
    local tonometers = self.items.tonometers

    return #tonometers > 0
end

function CheckBloodPressureHandler:perform(previousAction, tonometerType)
    if tonometerType then
        local tonometer = self:getItemOfType(self.items.tonometers, tonometerType)
        previousAction = self:toPlayerInventory(tonometer, previousAction)

        local action = CheckBloodPressureAction:new(self:getDoctor(), self:getPatient(), tonometer, self.bodyPart)

        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.blood.context_menu.handler.check_blood_pressure_handler',
    {
        CheckBloodPressureHandler
    },
    'imeds.context_menu.health_panel.handler'
)