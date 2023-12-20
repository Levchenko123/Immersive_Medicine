RenameBloodBagHandler = {}

function RenameBloodBagHandler:supports(item, player)
    self.item = item

    return item:getFullType() == FullBloodBag.fullType
end

function RenameBloodBagHandler:getActionTitle()
    return getText('UI_ContextMenu_Rename')
end

function RenameBloodBagHandler:addSubMenu(subMenu, player, item)
    subMenu:addOption(self.item:getName(), self.item, self.onRename, player)
end

RenameBloodBagHandler.onRename = function(item, player)
    local modal = ISTextBox:new(0, 0, 280, 180, getText('UI_ContextMenu_Rename') .. item:getName(), item:getDisplayName(), nil, RenameBloodBagHandler.onRenameSubmit, 0, player, item);
    modal:initialise();
    modal:addToUIManager();
end

function RenameBloodBagHandler:onRenameSubmit(button, player, item)
    local playerNum = player:getPlayerNum()
    if button.internal == 'OK' then
        if button.parent.entry:getText() and button.parent.entry:getText() ~= '' then
            item:setName(button.parent.entry:getText());
            item:setCustomName(true);

            local pdata = getPlayerData(playerNum);
            pdata.playerInventory:refreshBackpacks();
            pdata.lootInventory:refreshBackpacks();
        end
    end
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.drug.context_menu.handler.rename_blood_bag_handler_handler',
    {
        RenameBloodBagHandler
    },
    'imeds.context_menu.inventory_panel.handler'
)