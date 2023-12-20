NeedlePackHandler = {}

function NeedlePackHandler:supports(item, player)
    return item:getFullType() == NeedlePack.fullType
end

function NeedlePackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function NeedlePackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        if i > InventoryPanelMenuInitializer.maxItems then
            break
        end

        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

NeedlePackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromNeedlePackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.needle_pack_handler',
    {
        NeedlePackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)