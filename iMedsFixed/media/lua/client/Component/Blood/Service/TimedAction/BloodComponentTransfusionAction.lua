require 'TimedActions/ISBaseTimedAction'

BloodComponentTransfusionAction = {}
BloodComponentTransfusionAction = ISBaseTimedAction:derive('BloodComponentTransfusionAction')

function BloodComponentTransfusionAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    if self.erythrocyteSuspensionBag and self.catheter then
        return self.character:getInventory():contains(self.erythrocyteSuspensionBag)
            and self.character:getInventory():contains(self.plasmaBag)
            and self.character:getInventory():contains(self.catheter)
    end

    return false
end

function BloodComponentTransfusionAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function BloodComponentTransfusionAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    if self.erythrocyteSuspensionBag and self.plasmaBag and self.catheter then
        self.erythrocyteSuspensionBag:setJobDelta(self:getJobDelta())
        self.plasmaBag:setJobDelta(self:getJobDelta())
        self.catheter:setJobDelta(self:getJobDelta())
    end

    local jobType = getText('UI_ContextMenu_TransferBlood')
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, jobType, { transferBlood = true })

    self.character:setMetabolicTarget(Metabolics.LightWork)
end

function BloodComponentTransfusionAction:start()
    if self.catheter and self.erythrocyteSuspensionBag and self.plasmaBag then
        self.catheter:setJobType(getText("UI_ContextMenu_TransferBlood"))
        self.catheter:setJobDelta(0.0)
        self.erythrocyteSuspensionBag:setJobType(getText("UI_ContextMenu_TransferBlood"))
        self.erythrocyteSuspensionBag:setJobDelta(0.0)
        self.plasmaBag:setJobType(getText("UI_ContextMenu_TransferBlood"))
        self.plasmaBag:setJobDelta(0.0)
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

    self:setOverrideHandModels(self.erythrocyteSuspensionBag, self.plasmaBag)
end

function BloodComponentTransfusionAction:stop()
    if self.erythrocyteSuspensionBag and self.catheter and self.plasmaBag then
        self.erythrocyteSuspensionBag:setJobDelta(0.0)
        self.catheter:setJobDelta(0.0)
        self.plasmaBag:setJobDelta(0.0)
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
end

function BloodComponentTransfusionAction:perform()
    ISBaseTimedAction.perform(self)
    if self.erythrocyteSuspensionBag and self.catheter and self.plasmaBag then
        self.erythrocyteSuspensionBag:setJobDelta(0.0)
        self.catheter:setJobDelta(0.0)
        self.plasmaBag:setJobDelta(0.0)
    end

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
    end

    self.character:getXp():AddXP(Perks.Doctor, 1)

    local bloodVolumeIncreaser = InventoryItemFactory.CreateItem(BloodVolumeIncreaser.fullType)
    bloodVolumeIncreaser:getModData().blood = {
        group = BloodGroup[PlasmaBag:getBloodTypeByFullType(self.plasmaBag:getFullType())],
        volume = 500,
        maxVolume = 500,
        donor = {
            isInfected = false,
            poisonLevel = 0,
            drunkennessLevel = 0,
        },
    }
    bloodVolumeIncreaser:getModData().blood.isFresh = self.erythrocyteSuspensionBag:isFresh() and self.plasmaBag:isFresh()
    bloodVolumeIncreaser:getModData().blood.isRotten = self.erythrocyteSuspensionBag:isRotten() or self.plasmaBag:isRotten()

    if isClient() then
        local args = { patientOnlineId = self.otherPlayer:getOnlineID(), doctorOnlineId = self.character:getOnlineID(), item = bloodVolumeIncreaser }
        sendClientCommand(self.character, 'blood', TransferBloodCommand.defaultName, args)
    else
        self.character:sendObjectChange('addItem', { item = bloodVolumeIncreaser })
    end

    self.erythrocyteSuspensionBag:Use()
    self.plasmaBag:Use()
    self.catheter:Use()

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function BloodComponentTransfusionAction:new(doctor, patient, erythrocyteSuspensionBag, plasmaBag, catheter, bodyPart)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.erythrocyteSuspensionBag = erythrocyteSuspensionBag
    public.plasmaBag = plasmaBag
    public.catheter = catheter
    public.bodyPart = bodyPart
    public.stopOnWalk = true
    public.stopOnRun = true
    public.doIt = true
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.maxTime = 600 - (public.doctorLevel * 4)

    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    return public
end

return BloodComponentTransfusionAction