require 'TimedActions/ISBaseTimedAction'

TakeOneFromMorphinePackAction = {}
TakeOneFromMorphinePackAction = ISBaseTimedAction:derive('TakeOneFromMorphinePackAction')

function TakeOneFromMorphinePackAction:isValid()
    return self.character:getInventory():contains(self.item)
end

function TakeOneFromMorphinePackAction:start()
    self.item:setJobType(self.jobType)
    self.item:setJobDelta(0.0)

    self:setActionAnim(CharacterActionAnims.InsertBullets);

    self:setOverrideHandModels(self.item:getStaticModel(), nil)
    self.countStart = round(self.item:getDrainableUsesFloat())
end

function TakeOneFromMorphinePackAction:update()
    if self:isFinished() then
        self:setOverrideHandModels(nil, nil)
        self:forceComplete()

        return
    end

    local jobDelta = self.countStart - round(self.item:getDrainableUsesFloat())
    self.item:setJobDelta(jobDelta / self.count)
end

function TakeOneFromMorphinePackAction:isFinished()
    return self.countStart - round(self.item:getDrainableUsesFloat()) >= self.count or
        not self.character:getInventory():containsWithModule(self.item:getFullType())
end

function TakeOneFromMorphinePackAction:animEvent(event, parameter)
    if event == 'InsertBullet' then
        self.item:Use()

        local drug = InventoryItemFactory.CreateItem(Morphine.fullType)

        if isClient() then
            local args = { id = self.character:getOnlineID(), item = drug }
            sendClientCommand(self.character, 'drug', TakeOneCommand.defaultName, args)
        else
            self.character:sendObjectChange('addItem', { item = drug })
        end
    end
end

function TakeOneFromMorphinePackAction:stop()
    self.item:setJobDelta(0.0)

    ISBaseTimedAction.stop(self)
end

function TakeOneFromMorphinePackAction:perform()
    ISBaseTimedAction.perform(self)
    self.item:setJobDelta(0.0)
end

function TakeOneFromMorphinePackAction:new(player, item, count)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = player
    public.item = item
    public.count = count
    public.maxTime = -1
    public.jobType = getText('UI_ContextMenu_Take')
    public.stopOnWalk = false

    if player:isTimedActionInstant() then
        public.maxTime = 1
    end

    return public
end

return TakeOneFromMorphinePackAction