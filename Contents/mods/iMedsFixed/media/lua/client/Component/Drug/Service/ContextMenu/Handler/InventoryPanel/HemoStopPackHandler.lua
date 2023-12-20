HemoStopPackHandler = {}

function HemoStopPackHandler:supports(item, player)
    return item:getFullType() == HemoStopPack.fullType
end

function HemoStopPackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function HemoStopPackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

HemoStopPackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromHemoStopPackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.hemo_stop_pack_handler',
    {
        HemoStopPackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)