---@class ReceivePulseCheckRequestCommand
ReceivePulseCheckRequestCommand = {
    defaultName = 'receivePulseCheckRequest',
}

if not isClient() then
    return
end

ReceivePulseCheckRequestCommand.execute = function(package)
    if package.doctorOnlineId ~= nil and package.patientOnlineId ~= nil then
        package.pulse = Survivor:getBlood():getPulse()
        sendClientCommand(getSpecificPlayer(0), 'blood', CheckPulseCommand.defaultName, package)
    end
end

Events.OnServerCommand.Add(
    function(module, command, package)
        if module == 'blood' and command == ReceivePulseCheckRequestCommand.defaultName then
            ReceivePulseCheckRequestCommand.execute(package)
        end
    end
)
