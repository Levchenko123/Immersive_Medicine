---@class CheckPulseCommand
CheckPulseCommand = {
    defaultName = 'checkPulse',
}

if isClient() then
    return
end

CheckPulseCommand.execute = function(player, args)
    local doctor = getPlayerByOnlineID(args.doctorOnlineId)
    local patient = getPlayerByOnlineID(args.patientOnlineId)

    if doctor == nil or patient == nil then
        return false
    end

    local package = { patientOnlineId = args.patientOnlineId, doctorOnlineId = args.doctorOnlineId }
    if args.pulse == nil then
        print(doctor:getSteamID() .. ' performing pulse check to ' .. patient:getSteamID())
        --send request to patient
        sendServerCommand(patient, 'blood', 'receivePulseCheckRequest', package)
    else
        --receive response from patient and send to doctor
        package.pulse = args.pulse
        sendServerCommand(doctor, 'blood', 'receivePulse', package)
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'blood' and command == CheckPulseCommand.defaultName then
            CheckPulseCommand.execute(player, args)
        end
    end
)

