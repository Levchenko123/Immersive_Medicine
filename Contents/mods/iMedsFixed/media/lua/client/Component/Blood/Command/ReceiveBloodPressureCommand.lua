---@class ReceiveBloodPressureCommand
ReceiveBloodPressureCommand = {
    defaultName = 'receiveBloodPressure',
}

if not isClient() then
    return
end

ReceiveBloodPressureCommand.execute = function(package)
    local patient = getPlayerByOnlineID(package.patientOnlineId)
    if package.pulse ~= nil and package.bloodPressure ~= nil and patient ~= nil then
        BloodPressureWindow:setPatientName(patient:getDescriptor():getForename() .. ' ' .. patient:getDescriptor():getSurname())
        BloodPressureWindow:setPulse(package.pulse)
        BloodPressureWindow:setSystolicBloodPressure(package.bloodPressure.systolic)
        BloodPressureWindow:setDiastolicBloodPressure(package.bloodPressure.diastolic)
        BloodPressureWindow.instance:setVisible(true)
    end
end

Events.OnServerCommand.Add(
    function(module, command, package)
        if module == 'blood' and command == ReceiveBloodPressureCommand.defaultName then
            ReceiveBloodPressureCommand.execute(package)
        end
    end
)
