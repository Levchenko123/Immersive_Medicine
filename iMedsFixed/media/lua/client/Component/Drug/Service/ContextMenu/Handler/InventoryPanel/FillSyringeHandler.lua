FillSyringeHandler = {}

function FillSyringeHandler:supports(item, player)
    self.drugs = {}

    for i = 0, player:getInventory():getItems():size() - 1 do
        local drug = player:getInventory():getItems():get(i)
        if drug ~= nil
            and drug:getModData().drug ~= nil
            and drug:getModData().drug.dosageForms ~= nil
            and (
            drug:getModData().drug.dosageForms[DosageForm.Parenteral.Intramuscular.alias] ~= nil
                or drug:getModData().drug.dosageForms[DosageForm.Parenteral.Intravenous.alias] ~= nil
        )
        then
            table.insert(self.drugs, drug)
        end
    end

    return in_table(item:getFullType(), { SyringeWithNeedle.fullType, FullSyringeWithNeedle.fullType })
        and tableLength(self.drugs) > 0
end

function FillSyringeHandler:getActionTitle()
    return getText('UI_ContextMenu_FillSyringe')
end

function FillSyringeHandler:addSubMenu(subMenu, player, item)
    if item:getModData().syringe.volume < item:getModData().syringe.maxVolume then
        for _, drug in ipairs(self.drugs) do
            if item:getModData().syringe.drug == nil
                or item:getModData().syringe.drug ~= nil
                and item:getModData().syringe.drug.fullType == drug:getFullType()

            then
                local text = item:getName() .. " + " .. drug:getName()
                subMenu:addOption(text, item, self.action, player, drug)
            end
        end
    end
end

FillSyringeHandler.action = function(item, player, drug)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(FillSyringeAction:new(player, item, drug))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.fill_syringe_handler',
    {
        FillSyringeHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)