AlkaginPackHandler = {}

function AlkaginPackHandler:supports(item, player)
    return item:getFullType() == AlkaginPack.fullType
end

function AlkaginPackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function AlkaginPackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

AlkaginPackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromAlkaginPackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.alkagin_pack_handler',
    {
        AlkaginPackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)