---@class TransferBloodCommand
TransferBloodCommand = {
    defaultName = 'transferBlood',
}

if isClient() then
    return
end

TransferBloodCommand.execute = function(player, args)
    local doctor = getPlayerByOnlineID(args.doctorOnlineId)
    local patient = getPlayerByOnlineID(args.patientOnlineId)

    if doctor ~= nil and patient ~= nil then
        print(doctor:getSteamID() .. ' performing blood transfusion to ' .. patient:getSteamID())
        patient:sendObjectChange('addItem', { item = args.item })
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'blood' and command == TransferBloodCommand.defaultName then
            TransferBloodCommand.execute(player, args)
        end
    end
)

