require 'TimedActions/ISBaseTimedAction'

TakeDrugsParenteralAction = {}
TakeDrugsParenteralAction = ISBaseTimedAction:derive('TakeDrugsParenteralAction')

function TakeDrugsParenteralAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    if self.syringe then
        return self.character:getInventory():contains(self.syringe)
    end

    return false
end

function TakeDrugsParenteralAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function TakeDrugsParenteralAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    if self.syringe then
        self.syringe:setJobDelta(self:getJobDelta())
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { takeDrugs = true })
end

function TakeDrugsParenteralAction:start()
    if self.syringe then
        self.syringe:setJobType(self.jobType)
        self.syringe:setJobDelta(0.0)
    end

    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Bandage);
        self:setAnimVariable('BandageType', ISHealthPanel.getBandageType(self.bodyPart));
        self.character:reportEvent("EventBandage");
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
        self.character:reportEvent("EventLootItem")
    end

    self:setOverrideHandModels(self.item, nil)
end

function TakeDrugsParenteralAction:stop()
    if self.syringe then
        self.syringe:setJobDelta(0.0)
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
end

function TakeDrugsParenteralAction:perform()
    ISBaseTimedAction.perform(self)
    if self.syringe then
        self.syringe:setJobDelta(0.0)
    end

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50);
    end

    self.character:getXp():AddXP(Perks.Doctor, 0.1)

    local drugApplier = InventoryItemFactory.CreateItem(DrugApplier.fullType)
    drugApplier:getModData().drug = self.syringe:getModData().syringe.drug
    drugApplier:getModData().drug.dosageForm = self.dosageForm
    drugApplier:getModData().drug.dose = self.dosage

    if isClient() then
        local args = { doctorOnlineId = self.character:getOnlineID(), patientOnlineId = self.otherPlayer:getOnlineID(), item = drugApplier }
        sendClientCommand(self.character, 'drug', TakeDrugsCommand.defaultName, args)
    else
        self.character:sendObjectChange('addItem', { item = drugApplier })
    end

    for _ = 1, self.dosage do
        self.syringe:getModData().syringe.drug.dose = self.syringe:getModData().syringe.drug.dose - 1
        self.syringe:getModData().syringe.volume = self.syringe:getModData().syringe.volume - 1
        self.syringe:Use()
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function TakeDrugsParenteralAction:new(doctor, patient, syringe, bodyPart, dosageForm, dosage)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.syringe = syringe
    public.dosage = dosage
    public.bodyPart = bodyPart
    public.stopOnWalk = true
    public.stopOnRun = true
    public.doIt = true
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.maxTime = 60 - (public.doctorLevel * 4)
    public.jobType = DosageForm.Parenteral[dosageForm].action
    public.dosageForm = dosageForm

    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    return public
end

return TakeDrugsParenteralAction