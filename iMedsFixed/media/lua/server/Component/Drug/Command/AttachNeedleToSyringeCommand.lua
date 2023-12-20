---@class AttachNeedleToSyringeCommand
AttachNeedleToSyringeCommand = {
    defaultName = 'attachNeedleToSyringe',
}

if isClient() then
    return
end

AttachNeedleToSyringeCommand.execute = function(player, args)
    local otherPlayer = getPlayerByOnlineID(args.id)
    if otherPlayer then
        otherPlayer:sendObjectChange('addItem', { item = args.item })
    end
end

Events.OnClientCommand.Add(
    function(module, command, player, args)
        if module == 'drug' and command == AttachNeedleToSyringeCommand.defaultName then
            AttachNeedleToSyringeCommand.execute(player, args)
        end
    end
)

