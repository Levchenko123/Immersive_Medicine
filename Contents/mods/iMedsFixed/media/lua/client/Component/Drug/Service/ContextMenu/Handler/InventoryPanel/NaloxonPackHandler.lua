NaloxonPackHandler = {}

function NaloxonPackHandler:supports(item, player)
    return item:getFullType() == NaloxonPack.fullType
end

function NaloxonPackHandler:getActionTitle()
    return getText('UI_ContextMenu_Take')
end

function NaloxonPackHandler:addSubMenu(subMenu, player, item)
    for i = 1, round(item:getDrainableUsesFloat()) do
        subMenu:addOption(i .. '', item, self.action, player, i)
    end
end

NaloxonPackHandler.action = function(item, player, count)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(TakeOneFromNaloxonPackAction:new(player, item, count))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.naloxon_pack_handler',
    {
        NaloxonPackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)