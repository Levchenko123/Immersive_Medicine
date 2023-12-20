CheckBloodVolumeHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
CheckBloodVolumeHandler = BaseHandlerProxy:derive("CheckBloodVolumeHandler")

function CheckBloodVolumeHandler:new(panel, bodyPart)
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.tonometers = {}

    return public
end

function CheckBloodVolumeHandler:checkItem(item)
    if in_table(item:getFullType(), { BloodPressureMonitorRight.fullType, BloodPressureMonitorLeft.fullType }) then
        self:addItem(self.items.tonometers, item)
    end
end

function CheckBloodVolumeHandler:addToMenu(context)
    if self:getDoctor():getPerkLevel(Perks.Doctor) < 3 then
        return false
    end

    if not in_table(self.bodyPart:getType(), { BodyPart.UpperArm_R, BodyPart.UpperArm_L }) then
        return false
    end

    local tonometerTypes = self:getAllItemTypes(self.items.tonometers)

    if #tonometerTypes > 0 then
        local tonometer = self:getItemOfType(self.items.tonometers, tonometerTypes[1])
        context:addOption(getText("UI_ContextMenu_CheckBloodVolume"), self, self.onMenuOptionSelected, tonometer:getFullType())
    end
end

function CheckBloodVolumeHandler:dropItems(items)
    return false
end

function CheckBloodVolumeHandler:isValid(tonometerType)
    self:checkItems()
    local tonometers = self.items.tonometers

    return #tonometers > 0
end

function CheckBloodVolumeHandler:perform(previousAction, tonometerType)
    if tonometerType then
        local tonometer = self:getItemOfType(self.items.tonometers, tonometerType)
        previousAction = self:toPlayerInventory(tonometer, previousAction)

        local action = CheckBloodVolumeAction:new(self:getDoctor(), self:getPatient(), tonometer, self.bodyPart)

        ISTimedActionQueue.addAfter(previousAction, action)
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.blood.context_menu.handler.check_blood_volume_handler',
    {
        CheckBloodVolumeHandler
    },
    'imeds.context_menu.health_panel.handler'
)