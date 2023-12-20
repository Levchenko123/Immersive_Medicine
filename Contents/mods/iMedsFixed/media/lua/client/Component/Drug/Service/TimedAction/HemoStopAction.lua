require 'TimedActions/ISBaseTimedAction'

HemoStopAction = {}
HemoStopAction = ISBaseTimedAction:derive('HemoStopAction')

function HemoStopAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    return self.character:getInventory():contains(self.drug)
end

function HemoStopAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function HemoStopAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    self.drug:setJobDelta(self:getJobDelta())

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { takeDrugs = true })
end

function HemoStopAction:start()
    self.drug:setJobType(self.jobType)
    self.drug:setJobDelta(0.0)

    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Bandage);
        self:setAnimVariable("BandageType", ISHealthPanel.getBandageType(self.bodyPart));
        self.character:reportEvent("EventBandage");
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
        self.character:reportEvent("EventLootItem")
    end

    self:setOverrideHandModels(self.item, nil)
end

function HemoStopAction:stop()
    self.drug:setJobDelta(0.0)

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
end

function HemoStopAction:perform()
    ISBaseTimedAction.perform(self)
    self.drug:setJobDelta(0.0)

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50);
    end
    self.character:getXp():AddXP(Perks.Doctor, 0.1)

    local drugApplier = InventoryItemFactory.CreateItem(DrugApplier.fullType)
    drugApplier:getModData().drug = self.drug:getModData().drug
    drugApplier:getModData().drug.dosageForm = self.dosageForm
    drugApplier:getModData().drug.bodyPartType = BodyPartType.ToString(self.bodyPart:getType())

    if isClient() then
        local args = { doctorOnlineId = self.character:getOnlineID(), patientOnlineId = self.otherPlayer:getOnlineID(), item = drugApplier }
        sendClientCommand(self.character, 'drug', TakeDrugsCommand.defaultName, args)
    else
        self.character:sendObjectChange('addItem', { item = drugApplier })
    end

    for _ = 1, self.dosage do
        if round(self.drug:getDrainableUsesFloat()) > 0 then
            self.drug:Use()
        end
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function HemoStopAction:new(doctor, patient, drug, bodyPart, dosageForm, dosage)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.drug = drug
    public.bodyPart = bodyPart
    public.stopOnWalk = true
    public.stopOnRun = true
    public.doIt = true
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.maxTime = 60 - (public.doctorLevel * 4)
    public.jobType = DosageForm.Topical[dosageForm].action
    public.dosageForm = dosageForm
    public.dosage = dosage

    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    return public
end

return HemoStopAction