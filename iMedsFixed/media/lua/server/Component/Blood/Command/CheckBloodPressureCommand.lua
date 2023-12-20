---@class CheckBloodPressureCommand
CheckBloodPressureCommand = {
    defaultName = 'checkBloodPressure',
}

if isClient() then
    return
end

CheckBloodPressureCommand.execute = function(player, args)
    local doctor = getPlayerByOnlineID(args.doctorOnlineId)
    local patient = getPlayerByOnlineID(args.patientOnlineId)

    if doctor == nil or patient == nil then
        return false
    end

    local package = { patientOnlineId = args.patientOnlineId, doctorOnlineId = args.doctorOnlineId }
    if args.pulse == nil or args.bloodPressure == nil then
        print(doctor:getSteamID() .. ' performing blood pressure check to ' .. patient:getSteamID())
        --send request to patient
        sendServerCommand(patient, 'blood', 'receiveBloodPressureCheckRequest', package)
    else
        --receive response from patient and send to doctor
        package.bloodPressure = args.bloodPressure
        package.pulse = args.pulse
        sendServerCommand(doctor, 'blood', 'receiveBloodPressure', package)
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'blood' and command == CheckBloodPressureCommand.defaultName then
            CheckBloodPressureCommand.execute(player, args)
        end
    end
)

