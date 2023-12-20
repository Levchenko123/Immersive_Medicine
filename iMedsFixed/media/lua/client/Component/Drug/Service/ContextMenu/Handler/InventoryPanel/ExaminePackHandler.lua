ExaminePackHandler = {}

function ExaminePackHandler:supports(item, player)
    if player:HasTrait('Illiterate') then
        return false
    end

    ---@type DrugPackStorage
    local drugPackStorage = ZCore:getContainer():get('imeds.drug.storage.drug_pack_storage')

    return item:getModule() == 'iMeds'
        and item:getFullType() ~= UnknownPack.fullType
        and string.contains(item:getFullType(), 'Pack')
        and drugPackStorage:getByFullType(item:getFullType()) ~= nil
end

function ExaminePackHandler:getActionTitle()
    return getText('UI_ContextMenu_ExaminePack')
end

function ExaminePackHandler:addSubMenu(subMenu, player, item)
    subMenu:addOption(item:getName(), item, self.action, player)
end

ExaminePackHandler.action = function(item, player)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(ExamineDrugAction:new(player, item))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.examine_pack_handler',
    {
        ExaminePackHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)