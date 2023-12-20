CheckPulseHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
CheckPulseHandler = BaseHandlerProxy:derive("CheckPulseHandler")

function CheckPulseHandler:new(panel, bodyPart)
    return BaseHandlerProxy.new(self, panel, bodyPart)
end

function CheckPulseHandler:checkItem(item)
    return true
end

function CheckPulseHandler:addToMenu(context)
    if not in_table(self.bodyPart:getType(), { BodyPart.Neck, BodyPart.ForeArm_R, BodyPart.ForeArm_L, BodyPart.Hand_R, BodyPart.Hand_L, BodyPart.Groin }) then
        return false
    end

    context:addOption(getText('UI_ContextMenu_CheckPulse'), self, self.onMenuOptionSelected, nil)
end

function CheckPulseHandler:dropItems(items)
    return false
end

function CheckPulseHandler:isValid(item)
    return true
end

function CheckPulseHandler:perform(previousAction, item)
    local action = CheckPulseAction:new(self:getDoctor(), self:getPatient(), nil, self.bodyPart)
    ISTimedActionQueue.addAfter(previousAction, action)
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.blood.context_menu.handler.check_pulse_handler',
    {
        CheckPulseHandler
    },
    'imeds.context_menu.health_panel.handler'
)