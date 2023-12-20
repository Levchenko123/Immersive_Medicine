SyringePackHandler = {}

function SyringePackHandler:supports(item, player)
    return item:getFullType() == SyringePack.fullType
end

function SyringePackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function SyringePackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

SyringePackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromSyringePackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.syringe_pack_handler',
    {
        SyringePackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)