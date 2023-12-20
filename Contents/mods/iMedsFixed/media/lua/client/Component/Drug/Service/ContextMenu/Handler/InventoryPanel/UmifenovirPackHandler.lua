UmifenovirPackHandler = {}

function UmifenovirPackHandler:supports(item, player)
    return item:getFullType() == UmifenovirPack.fullType
end

function UmifenovirPackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function UmifenovirPackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

UmifenovirPackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromUmifenovirPackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.umifenovir_pack_handler',
    {
        UmifenovirPackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)