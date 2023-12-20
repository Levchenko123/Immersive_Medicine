require 'TimedActions/ISBaseTimedAction'

TakeOneFromUnknownPackAction = {}
TakeOneFromUnknownPackAction = ISBaseTimedAction:derive('TakeOneFromUnknownPackAction')

function TakeOneFromUnknownPackAction:isValid()
    if self.character:getPerkLevel(Perks.Doctor) < 3 and not self.character:HasTrait(Pharmacist.alias) then
        return false
    end

    return self.character:getInventory():contains(self.item)
end

function TakeOneFromUnknownPackAction:start()
    self.item:setJobType(self.jobType)
    self.item:setJobDelta(0.0)

    self:setActionAnim(CharacterActionAnims.InsertBullets);

    self:setOverrideHandModels(self.item:getStaticModel(), nil)
    self.countStart = round(self.item:getDrainableUsesFloat())
end

function TakeOneFromUnknownPackAction:update()
    if self:isFinished() then
        self:setOverrideHandModels(nil, nil)
        self:forceComplete()

        return
    end

    local jobDelta = self.countStart - round(self.item:getDrainableUsesFloat())
    self.item:setJobDelta(jobDelta / self.count)
end

function TakeOneFromUnknownPackAction:isFinished()
    return self.countStart - round(self.item:getDrainableUsesFloat()) >= self.count or
        not self.character:getInventory():containsWithModule(self.item:getFullType())
end

function TakeOneFromUnknownPackAction:animEvent(event, parameter)
    if event == 'InsertBullet' then
        self.item:Use()

        ---@type DrugPackStorage
        local drugPackStorage = ZCore:getContainer():get('imeds.drug.storage.drug_pack_storage')
        local pack = InventoryItemFactory.CreateItem(drugPackStorage:getOneByRandom():getFullType())

        if isClient() then
            local args = { id = self.character:getOnlineID(), item = pack }
            sendClientCommand(self.character, 'drug', TakeOneCommand.defaultName, args)
        else
            self.character:sendObjectChange('addItem', { item = pack })
        end
    end
end

function TakeOneFromUnknownPackAction:stop()
    self.item:setJobDelta(0.0)

    ISBaseTimedAction.stop(self)
end

function TakeOneFromUnknownPackAction:perform()
    ISBaseTimedAction.perform(self)
    self.item:setJobDelta(0.0)
end

function TakeOneFromUnknownPackAction:new(player, item, count)
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

return TakeOneFromUnknownPackAction