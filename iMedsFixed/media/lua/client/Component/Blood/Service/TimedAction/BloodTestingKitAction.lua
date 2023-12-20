require 'TimedActions/ISBaseTimedAction'

BloodTestingKitAction = {}
BloodTestingKitAction = ISBaseTimedAction:derive('BloodTestingKitAction')

function BloodTestingKitAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    if self.kit then
        return self.character:getInventory():contains(self.kit) and self.kit:getDrainableUsesInt() == 1
    end

    return false
end

function BloodTestingKitAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function BloodTestingKitAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    if self.kit then
        self.kit:setJobDelta(self:getJobDelta())
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { testBlood = true })
end

function BloodTestingKitAction:start()
    if self.kit then
        self.kit:setJobType(self.jobType)
        self.kit:setJobDelta(0.0)
    end

    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Bandage)
        self:setAnimVariable('BandageType', ISHealthPanel.getBandageType(self.bodyPart))
        self.character:reportEvent('EventBandage')
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
        self.character:reportEvent('EventLootItem')
    end

    self:setOverrideHandModels(self.kit, nil)
end

function BloodTestingKitAction:stop()
    if self.kit then
        self.kit:setJobDelta(0.0)
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
end

function BloodTestingKitAction:perform()
    ISBaseTimedAction.perform(self)
    if self.kit then
        self.kit:setJobDelta(0.0)
    end

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
    end

    self.character:getXp():AddXP(Perks.Doctor, 1)

    if isClient() then
        local args = { patientOnlineId = self.otherPlayer:getOnlineID(), doctorOnlineId = self.character:getOnlineID() }
        sendClientCommand(self.character, 'blood', TestBloodCommand.defaultName, args)
    else
        local bloodTester = InventoryItemFactory.CreateItem('iMeds.BloodTester')
        self.character:sendObjectChange('addItem', { item = bloodTester })
    end

    self.kit:Use()

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function BloodTestingKitAction:new(doctor, patient, kit, bodyPart)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.kit = kit
    public.bodyPart = bodyPart
    public.stopOnWalk = true
    public.stopOnRun = true
    public.doIt = true
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.maxTime = 150 - (public.doctorLevel * 4)
    public.jobType = getText('UI_ContextMenu_TestBlood')

    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    return public
end

return BloodTestingKitAction