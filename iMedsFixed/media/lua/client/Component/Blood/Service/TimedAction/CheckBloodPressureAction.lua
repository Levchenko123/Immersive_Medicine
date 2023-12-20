require 'TimedActions/ISBaseTimedAction'

CheckBloodPressureAction = {}
CheckBloodPressureAction = ISBaseTimedAction:derive('CheckBloodPressureAction')

function CheckBloodPressureAction:isValid()
    if self.character == self.otherPlayer then
        return self.character:isEquipped(self.item)
    end

    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    return self.character:getInventory():contains(self.item)
end

function CheckBloodPressureAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function CheckBloodPressureAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    if self.item then
        self.item:setJobDelta(self:getJobDelta())
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { checkBloodPressure = true })
end

function CheckBloodPressureAction:start()
    self.item:setJobType(self.jobType)
    self.item:setJobDelta(0.0)

    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Bandage)
        self:setAnimVariable('BandageType', ISHealthPanel.getBandageType(self.bodyPart))
        self.character:reportEvent("EventBandage")
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
        self.character:reportEvent("EventLootItem")
    end
end

function CheckBloodPressureAction:update()
    self.item:setJobDelta(self.item:getJobDelta())
end

function CheckBloodPressureAction:stop()
    self.item:setJobDelta(0.0)

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
end

function CheckBloodPressureAction:perform()
    ISBaseTimedAction.perform(self)
    self.item:setJobDelta(0.0)

    if isClient() and self.character ~= self.otherPlayer then
        local args = { patientOnlineId = self.otherPlayer:getOnlineID(), doctorOnlineId = self.character:getOnlineID() }
        sendClientCommand(self.character, 'blood', CheckBloodPressureCommand.defaultName, args)
    else
        BloodPressureMonitorMenu:updateSystolicBloodPressure()
        BloodPressureMonitorMenu:updateDiastolicBloodPressure()
        BloodPressureMonitorMenu:updatePulse()
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function CheckBloodPressureAction:new(doctor, patient, item, bodyPart)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor
    public.otherPlayer = patient
    public.bodyPart = patient
    public.item = item
    public.bodyPart = bodyPart
    public.maxTime = 300
    public.jobType = getText('UI_ContextMenu_CheckBloodPressure')
    public.stopOnWalk = false
    public.stopOnRun = false
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()

    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    return public
end

return CheckBloodPressureAction