ErythropoietinPackHandler = {}

function ErythropoietinPackHandler:supports(item, player)
    return item:getFullType() == ErythropoietinPack.fullType
end

function ErythropoietinPackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function ErythropoietinPackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

ErythropoietinPackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromErythropoietinPackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.erythropoietin_pack_handler',
    {
        ErythropoietinPackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)