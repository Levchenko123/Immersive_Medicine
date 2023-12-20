---@class DonateBloodCommand
DonateBloodCommand = {
    defaultName = 'donateBlood',
}

if isClient() then
    return
end

DonateBloodCommand.execute = function(player, args)
    local doctor = getPlayerByOnlineID(args.doctorOnlineId)
    local patient = getPlayerByOnlineID(args.patientOnlineId)

    if doctor ~= nil and patient ~= nil then
        local bloodVolumeReducer = InventoryItemFactory.CreateItem('iMeds.BloodVolumeReducer')
        print(doctor:getSteamID() .. ' performing blood donation to ' .. patient:getSteamID())
        patient:sendObjectChange('addItem', { item = bloodVolumeReducer })
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'blood' and command == DonateBloodCommand.defaultName then
            DonateBloodCommand.execute(player, args)
        end
    end
)

