BaseHandlerProxy = {}
BaseHandlerProxy = ISBaseObject:derive("BaseHandler")

function BaseHandlerProxy:new(panel, bodyPart)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.panel = panel
    o.bodyPart = bodyPart
    o.items = {}
    return o
end

function BaseHandlerProxy:isInjured()
    local bodyPart = self.bodyPart
    return (bodyPart:HasInjury() or bodyPart:stitched() or bodyPart:getSplintFactor() > 0) and not bodyPart:bandaged()
end

function BaseHandlerProxy:checkItems()
    for k, v in pairs(self.items) do
        table.wipe(v)
    end

    local containers = ISInventoryPaneContextMenu.getContainers(self:getDoctor())
    local done = {}
    local childContainers = {}
    for i = 1, containers:size() do
        local container = containers:get(i - 1)
        done[container] = true
        table.wipe(childContainers)
        self:checkContainerItems(container, childContainers)
        for _, container2 in ipairs(childContainers) do
            if not done[container2] then
                done[container2] = true
                self:checkContainerItems(container2, nil)
            end
        end
    end
end

function BaseHandlerProxy:checkContainerItems(container, childContainers)
    local containerItems = container:getItems()
    for i = 1, containerItems:size() do
        local item = containerItems:get(i - 1)
        if item:IsInventoryContainer() then
            if childContainers then
                table.insert(childContainers, item:getInventory())
            end
        else
            self:checkItem(item)
        end
    end
end

function BaseHandlerProxy:dropItems(items)
    return false
end

function BaseHandlerProxy:addItem(items, item)
    table.insert(items, item)
end

function BaseHandlerProxy:getAllItemTypes(items)
    local done = {}
    local types = {}
    for _, item in ipairs(items) do
        if not done[item:getFullType()] then
            table.insert(types, item:getFullType())
            done[item:getFullType()] = true
        end
    end
    return types
end

function BaseHandlerProxy:getItemOfType(items, type)
    for _, item in ipairs(items) do
        if item:getFullType() == type then
            return item
        end
    end
    return nil
end

function BaseHandlerProxy:getAllItemsOfType(items, type)
    local items = {}
    for _, item in ipairs(items) do
        if item:getFullType() == type then
            table.insert(items, item)
        end
    end
    return items
end

function BaseHandlerProxy:onMenuOptionSelected(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    ISTimedActionQueue.add(HealthPanelAction:new(self:getDoctor(), self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8))
end

function BaseHandlerProxy:toPlayerInventory(item, previousAction)
    if item:getContainer() ~= self:getDoctor():getInventory() then
        local action = ISInventoryTransferAction:new(self:getDoctor(), item, item:getContainer(), self:getDoctor():getInventory())
        ISTimedActionQueue.addAfter(previousAction, action)
        -- FIXME: ISHealthPanel.actions never gets cleared
        self.panel.actions = self.panel.actions or {}
        self.panel.actions[action] = self.bodyPart
        return action
    end
    return previousAction
end

function BaseHandlerProxy:getDoctor()
    return self.panel.otherPlayer or self.panel.character
end

function BaseHandlerProxy:getPatient()
    return self.panel.character
end

return BaseHandlerProxy