MorphinePackHandler = {}

function MorphinePackHandler:supports(item, player)
    return item:getFullType() == MorphinePack.fullType
end

function MorphinePackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function MorphinePackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

MorphinePackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromMorphinePackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.morphine_pack_handler',
    {
        MorphinePackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)