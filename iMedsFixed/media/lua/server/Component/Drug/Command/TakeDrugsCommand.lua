---@class TakeDrugsCommand
TakeDrugsCommand = {
    defaultName = 'takeDrugs',
}

if isClient() then
    return
end

TakeDrugsCommand.execute = function(player, args)
    local patient = getPlayerByOnlineID(args.patientOnlineId)
    local doctor = getPlayerByOnlineID(args.doctorOnlineId)
    if patient ~= nil and doctor ~= nil then
        print(doctor:getSteamID() .. ' injects ' .. args.item:getModData().drug.fullType .. ' to ' .. patient:getSteamID())
        patient:sendObjectChange('addItem', { item = args.item })
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'drug' and command == TakeDrugsCommand.defaultName then
            TakeDrugsCommand.execute(player, args)
        end
    end
)

