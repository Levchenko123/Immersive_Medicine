require 'TimedActions/ISBaseTimedAction'

DonateBloodAction = {}
DonateBloodAction = ISBaseTimedAction:derive('DonateBloodAction');

function DonateBloodAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    if self.emptyBloodBag and self.catheter then
        return self.character:getInventory():contains(self.emptyBloodBag)
            and self.character:getInventory():contains(self.catheter)
    end

    return false
end

function DonateBloodAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function DonateBloodAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    if self.emptyBloodBag and self.catheter then
        self.emptyBloodBag:setJobDelta(self:getJobDelta());
        self.catheter:setJobDelta(self:getJobDelta());
    end

    local jobType = getText('UI_ContextMenu_DonateBlood')
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, jobType, { donateBlood = true })

    self.character:setMetabolicTarget(Metabolics.LightWork);
end

function DonateBloodAction:start()
    if self.catheter and self.emptyBloodBag then
        self.catheter:setJobType(getText("UI_ContextMenu_DonateBlood"));
        self.catheter:setJobDelta(0.0);
        self.emptyBloodBag:setJobType(getText("UI_ContextMenu_DonateBlood"));
        self.emptyBloodBag:setJobDelta(0.0);
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

    self:setOverrideHandModels(self.emptyBloodBag, self.catheter);
end

function DonateBloodAction:stop()
    if self.emptyBloodBag and self.catheter then
        self.emptyBloodBag:setJobDelta(0.0);
        self.catheter:setJobDelta(0.0);
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self);
end

function DonateBloodAction:perform()
    ISBaseTimedAction.perform(self);
    if self.emptyBloodBag and self.catheter then
        self.emptyBloodBag:setJobDelta(0.0);
        self.catheter:setJobDelta(0.0);
    end

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50);
    end

    self.character:getXp():AddXP(Perks.Doctor, 1)

    if isClient() then
        local args = { patientOnlineId = self.otherPlayer:getOnlineID(), doctorOnlineId = self.character:getOnlineID() }
        sendClientCommand(self.character, 'blood', DonateBloodCommand.defaultName, args)
    else
        local bloodVolumeReducer = InventoryItemFactory.CreateItem(BloodVolumeReducer.fullType)
        self.character:sendObjectChange('addItem', { item = bloodVolumeReducer })
    end

    self.emptyBloodBag:Use()
    self.catheter:Use()

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function DonateBloodAction:new(doctor, patient, emptyBloodBag, catheter, bodyPart)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor;
    public.otherPlayer = patient;
    public.emptyBloodBag = emptyBloodBag;
    public.catheter = catheter;
    public.bodyPart = bodyPart;
    public.stopOnWalk = true;
    public.stopOnRun = true;
    public.doIt = true;
    public.patientPositionX = patient:getX();
    public.patientPositionY = patient:getY();
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor);
    public.maxTime = 600 - (public.doctorLevel * 4);

    if doctor:isTimedActionInstant() then
        public.maxTime = 1;
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10;
    end

    return public;
end

return DonateBloodAction