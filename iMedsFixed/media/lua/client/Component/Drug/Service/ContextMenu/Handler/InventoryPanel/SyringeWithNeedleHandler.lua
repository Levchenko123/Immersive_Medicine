SyringeWithNeedleHandler = {}

function SyringeWithNeedleHandler:supports(item, player)
    self.needles = {}

    local items = getSpecificPlayer(0):getInventory():getAllTypeRecurse(Needle.fullType)
    for i = 0, items:size() - 1 do
        local needle = items:get(i)
        if needle:getModData().needle ~= nil then
            table.insert(self.needles, needle)
        end
    end

    return item:getFullType() == Syringe.fullType and tableLength(self.needles) > 0
end

function SyringeWithNeedleHandler:getActionTitle()
    return getText('UI_ContextMenu_AttachNeedleToSyringe')
end

function SyringeWithNeedleHandler:addSubMenu(subMenu, player, item)
    for _, needle in ipairs(self.needles) do
        local text = item:getName() .. " + " .. needle:getName()
        subMenu:addOption(text, item, self.action, player, needle)
    end
end

SyringeWithNeedleHandler.action = function(item, player, needle)
    if luautils.haveToBeTransfered(player, item) then
        ISTimedActionQueue.add(
            ISInventoryTransferAction:new(player, item, item:getContainer(), player:getInventory())
        )
    end

    ISTimedActionQueue.add(AttachNeedleToSyringeAction:new(player, item, needle))
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.syringe_with_needle_handler',
    {
        SyringeWithNeedleHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)