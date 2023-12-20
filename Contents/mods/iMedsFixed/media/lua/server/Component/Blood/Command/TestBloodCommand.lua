---@class TestBloodCommand
TestBloodCommand = {
    defaultName = 'testBlood',
}

if isClient() then
    return
end

TestBloodCommand.execute = function(player, args)
    local doctor = getPlayerByOnlineID(args.doctorOnlineId)
    local patient = getPlayerByOnlineID(args.patientOnlineId)

    if doctor ~= nil and patient ~= nil then
        local bloodTester = InventoryItemFactory.CreateItem('iMeds.BloodTester')
        print(doctor:getSteamID() .. ' performing blood testing to ' .. patient:getSteamID())
        patient:sendObjectChange('addItem', { item = bloodTester })
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'blood' and command == TestBloodCommand.defaultName then
            TestBloodCommand.execute(player, args)
        end
    end
)

