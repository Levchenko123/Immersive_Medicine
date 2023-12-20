require 'TimedActions/ISBaseTimedAction'

TakeDrugsIntranasalAction = {}
TakeDrugsIntranasalAction = ISBaseTimedAction:derive('TakeDrugsIntranasalAction')

function TakeDrugsIntranasalAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    if self.drug then
        return self.character:getInventory():contains(self.drug)
    end

    return false
end

function TakeDrugsIntranasalAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function TakeDrugsIntranasalAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    if self.drug then
        self.drug:setJobDelta(self:getJobDelta())
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { takeDrugs = true })
end

function TakeDrugsIntranasalAction:start()
    if self.drug then
        self.drug:setJobType(self.jobType)
        self.drug:setJobDelta(0.0)
    end

    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Drink)
        self.character:reportEvent("EventEating")
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
        self.character:reportEvent("EventLootItem")
    end

    self:setOverrideHandModels(self.item, nil)
end

function TakeDrugsIntranasalAction:stop()
    if self.drug then
        self.drug:setJobDelta(0.0)
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
end

function TakeDrugsIntranasalAction:perform()
    ISBaseTimedAction.perform(self)
    if self.drug then
        self.drug:setJobDelta(0.0)
    end

    self.character:getXp():AddXP(Perks.Doctor, 0.1)

    local drugApplier = InventoryItemFactory.CreateItem(DrugApplier.fullType)
    drugApplier:getModData().drug = self.drug:getModData().drug
    drugApplier:getModData().drug.dosageForm = self.dosageForm

    if isClient() then
        local args = { doctorOnlineId = self.character:getOnlineID(), patientOnlineId = self.otherPlayer:getOnlineID(), item = drugApplier }
        sendClientCommand(self.character, 'drug', TakeDrugsCommand.defaultName, args)
    else
        self.character:sendObjectChange('addItem', { item = drugApplier })
    end

    for _ = 1, self.drug:getModData().drug.singleDose do
        if round(self.drug:getDrainableUsesFloat()) > 0 then
            self.drug:Use()
        end
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function TakeDrugsIntranasalAction:new(doctor, patient, drug, bodyPart, dosageForm)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.drug = drug
    public.bodyPart = bodyPart
    public.stopOnWalk = false
    public.stopOnRun = false
    public.doIt = true
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.maxTime = 200 - (public.doctorLevel * 4)
    public.jobType = DosageForm.Intranasal[dosageForm].action
    public.dosageForm = dosageForm

    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    return public
end

return TakeDrugsIntranasalAction