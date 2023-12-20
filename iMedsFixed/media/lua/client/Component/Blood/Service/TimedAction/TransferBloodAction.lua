require 'TimedActions/ISBaseTimedAction'

TransferBloodAction = {}
TransferBloodAction = ISBaseTimedAction:derive('TransferBloodAction');

function TransferBloodAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    if self.fullBloodBag and self.catheter then
        return self.character:getInventory():contains(self.fullBloodBag)
            and self.character:getInventory():contains(self.catheter)
    end

    return false
end

function TransferBloodAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function TransferBloodAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    if self.fullBloodBag and self.catheter then
        self.fullBloodBag:setJobDelta(self:getJobDelta());
        self.catheter:setJobDelta(self:getJobDelta());
    end

    local jobType = getText('UI_ContextMenu_TransferBlood')
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, jobType, { transferBlood = true })

    self.character:setMetabolicTarget(Metabolics.LightWork);
end

function TransferBloodAction:start()
    if self.catheter and self.fullBloodBag then
        self.catheter:setJobType(getText("UI_ContextMenu_TransferBlood"));
        self.catheter:setJobDelta(0.0);
        self.fullBloodBag:setJobType(getText("UI_ContextMenu_TransferBlood"));
        self.fullBloodBag:setJobDelta(0.0);
    end

    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Bandage);
        self:setAnimVariable('BandageType', ISHealthPanel.getBandageType(self.bodyPart));
        self.character:reportEvent('EventBandage');
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
        self.character:reportEvent('EventLootItem');
    end

    self:setOverrideHandModels(self.fullBloodBag, self.catheter);
end

function TransferBloodAction:stop()
    if self.fullBloodBag and self.catheter then
        self.fullBloodBag:setJobDelta(0.0);
        self.catheter:setJobDelta(0.0);
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self);
end

function TransferBloodAction:perform()
    ISBaseTimedAction.perform(self);
    if self.fullBloodBag and self.catheter then
        self.fullBloodBag:setJobDelta(0.0);
        self.catheter:setJobDelta(0.0);
    end

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50);
    end

    self.character:getXp():AddXP(Perks.Doctor, 1)

    local bloodVolumeIncreaser = InventoryItemFactory.CreateItem(BloodVolumeIncreaser.fullType)
    bloodVolumeIncreaser:getModData().blood = self.fullBloodBag:getModData().blood
    bloodVolumeIncreaser:getModData().blood.isFresh = self.fullBloodBag:isFresh()
    bloodVolumeIncreaser:getModData().blood.isRotten = self.fullBloodBag:isRotten()

    if isClient() then
        local args = { patientOnlineId = self.otherPlayer:getOnlineID(), doctorOnlineId = self.character:getOnlineID(), item = bloodVolumeIncreaser }
        sendClientCommand(self.character, 'blood', TransferBloodCommand.defaultName, args)
    else
        self.character:sendObjectChange('addItem', { item = bloodVolumeIncreaser })
    end

    self.fullBloodBag:Use()
    self.catheter:Use()

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function TransferBloodAction:new(doctor, patient, fullBloodBag, catheter, bodyPart)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor;
    public.otherPlayer = patient;
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor);
    public.fullBloodBag = fullBloodBag;
    public.catheter = catheter;
    public.bodyPart = bodyPart;
    public.stopOnWalk = true;
    public.stopOnRun = true;
    public.patientPositionX = patient:getX();
    public.patientPositionY = patient:getY();
    public.maxTime = 600 - (public.doctorLevel * 4);

    if doctor:isTimedActionInstant() then
        public.maxTime = 1;
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10;
    end

    return public;
end

return TransferBloodAction