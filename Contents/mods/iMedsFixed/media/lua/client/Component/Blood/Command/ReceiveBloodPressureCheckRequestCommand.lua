---@class ReceiveBloodPressureCheckRequestCommand
ReceiveBloodPressureCheckRequestCommand = {
    defaultName = 'receiveBloodPressureCheckRequest',
}

if not isClient() then
    return
end

ReceiveBloodPressureCheckRequestCommand.execute = function(package)
    if package.doctorOnlineId ~= nil and package.patientOnlineId ~= nil then
        package.bloodPressure = {
            systolic = Survivor:getBlood():getPressure():getSystolic(),
            diastolic = Survivor:getBlood():getPressure():getDiastolic(),
        }
        package.pulse = Survivor:getBlood():getPulse()
        sendClientCommand(getSpecificPlayer(0), 'blood', CheckBloodPressureCommand.defaultName, package)
    end
end

Events.OnServerCommand.Add(
    function(module, command, package)
        if module == 'blood' and command == ReceiveBloodPressureCheckRequestCommand.defaultName then
            ReceiveBloodPressureCheckRequestCommand.execute(package)
        end
    end
)
