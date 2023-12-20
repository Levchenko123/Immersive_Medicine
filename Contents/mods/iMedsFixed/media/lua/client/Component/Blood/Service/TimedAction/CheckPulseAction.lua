require 'TimedActions/ISBaseTimedAction'

CheckPulseAction = {}
CheckPulseAction = ISBaseTimedAction:derive('CheckPulseAction')

function CheckPulseAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    return true
end

function CheckPulseAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function CheckPulseAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { checkPulse = true })
end

function CheckPulseAction:start()
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

function CheckPulseAction:stop()
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
end

function CheckPulseAction:perform()
    ISBaseTimedAction.perform(self)
    self.character:getXp():AddXP(Perks.Doctor, 0.05)

    if isClient() then
        local args = { patientOnlineId = self.otherPlayer:getOnlineID(), doctorOnlineId = self.character:getOnlineID() }
        sendClientCommand(self.character, 'blood', CheckPulseCommand.defaultName, args)
    else
        PulseWindow:showPulse(Survivor:getBlood():getPulse(), self.character, self.character)
        PulseWindow:setVisible(true)
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function CheckPulseAction:new(doctor, patient, item, bodyPart)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = doctor
    public.otherPlayer = patient
    public.item = item
    public.bodyPart = bodyPart
    public.stopOnWalk = false
    public.stopOnRun = false
    public.jobType = getText('UI_ContextMenu_CheckPulse')
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.maxTime = 300 - (public.doctorLevel * 4)

    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    return public
end

return CheckPulseAction