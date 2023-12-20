---@class FillSyringeCommand
FillSyringeCommand = {
    defaultName = 'fillSyringe',
}

if isClient() then
    return
end

FillSyringeCommand.execute = function(player, args)
    local otherPlayer = getPlayerByOnlineID(args.id)
    if otherPlayer then
        otherPlayer:sendObjectChange('addItem', { item = args.item })
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'drug' and command == FillSyringeCommand.defaultName then
            FillSyringeCommand.execute(player, args)
        end
    end
)

