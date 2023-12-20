NasivionPackHandler = {}

function NasivionPackHandler:supports(item, player)
    return item:getFullType() == NasivionPack.fullType
end

function NasivionPackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function NasivionPackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

NasivionPackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromNasivionPackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.nasivion_pack_handler',
    {
        NasivionPackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)