---@class ReceiveBloodVolumeCheckRequestCommand
ReceiveBloodVolumeCheckRequestCommand = {
    defaultName = 'receiveBloodVolumeCheckRequest',
}

if not isClient() then
    return
end

ReceiveBloodVolumeCheckRequestCommand.execute = function(package)
    if package.doctorOnlineId ~= nil and package.patientOnlineId ~= nil then
        local bloodVolumeThreshold = Survivor:getBlood():getBloodLossVolume()
        local bloodVolume = Blood.maxVolume

        if bloodVolumeThreshold.from ~= nil then
            bloodVolume = bloodVolume - bloodVolumeThreshold.from
        end

        package.bloodVolume = bloodVolume

        sendClientCommand(getSpecificPlayer(0), 'blood', CheckBloodVolumeCommand.defaultName, package)
    end
end

Events.OnServerCommand.Add(
    function(module, command, package)
        if module == 'blood' and command == ReceiveBloodVolumeCheckRequestCommand.defaultName then
            ReceiveBloodVolumeCheckRequestCommand.execute(package)
        end
    end
)
