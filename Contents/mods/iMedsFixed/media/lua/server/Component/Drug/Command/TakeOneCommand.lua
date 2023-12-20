---@class TakeOneCommand
TakeOneCommand = {
    defaultName = 'takeOne',
}

if isClient() then
    return
end

TakeOneCommand.execute = function(player, args)
    local otherPlayer = getPlayerByOnlineID(args.id)
    if otherPlayer then
        otherPlayer:sendObjectChange('addItem', { item = args.item })
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'drug' and command == TakeOneCommand.defaultName then
            TakeOneCommand.execute(player, args)
        end
    end
)

