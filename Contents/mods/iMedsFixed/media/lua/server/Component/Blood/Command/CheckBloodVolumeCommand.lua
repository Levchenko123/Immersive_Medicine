---@class CheckBloodVolumeCommand
CheckBloodVolumeCommand = {
    defaultName = 'checkBloodVolume',
}

if isClient() then
    return
end

CheckBloodVolumeCommand.execute = function(player, args)
    local doctor = getPlayerByOnlineID(args.doctorOnlineId)
    local patient = getPlayerByOnlineID(args.patientOnlineId)

    if doctor == nil or patient == nil then
        return false
    end

    local package = { patientOnlineId = args.patientOnlineId, doctorOnlineId = args.doctorOnlineId }
    if args.bloodVolume == nil then
        print(doctor:getSteamID() .. ' performing blood volume check to ' .. patient:getSteamID())
        --send request to patient
        sendServerCommand(patient, 'blood', 'receiveBloodVolumeCheckRequest', package)
    else
        --receive response from patient and send to doctor
        package.bloodVolume = args.bloodVolume
        sendServerCommand(doctor, 'blood', 'receiveBloodVolume', package)
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'blood' and command == CheckBloodVolumeCommand.defaultName then
            CheckBloodVolumeCommand.execute(player, args)
        end
    end
)

