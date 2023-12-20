---@class SendLaceration
SendLaceration = {
    defaultName = 'sendLaceration',
}

if isClient() then
    return
end

SendLaceration.execute = function(player, args)
    local doctor = getPlayerByOnlineID(args.doctorOnlineId)
    local patient = getPlayerByOnlineID(args.patientOnlineId)

    if doctor == nil or patient == nil then
        return false
    end

    sendServerCommand(patient, 'surgery', 'receiveLaceration', args)
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'surgery' and command == SendLaceration.defaultName then
            SendLaceration.execute(player, args)
        end
    end
)

