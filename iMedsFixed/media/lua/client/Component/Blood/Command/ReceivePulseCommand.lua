---@class ReceivePulseCommand
ReceivePulseCommand = {
    defaultName = 'receivePulse',
}

if not isClient() then
    return
end

ReceivePulseCommand.execute = function(package)
    local patient = getPlayerByOnlineID(package.patientOnlineId)
    if package.pulse ~= nil and patient ~= nil then
        PulseWindow:showPulse(package.pulse, getSpecificPlayer(0), patient)
        PulseWindow:setVisible(true)
    end
end

Events.OnServerCommand.Add(
    function(module, command, package)
        if module == 'blood' and command == ReceivePulseCommand.defaultName then
            ReceivePulseCommand.execute(package)
        end
    end
)
