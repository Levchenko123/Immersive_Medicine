require 'TimedActions/ISBaseTimedAction'

StitchCutWoundAction = ISBaseTimedAction:derive('StitchCutWoundAction')

function StitchCutWoundAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    return self.character:getInventory():contains(self.needle)
        and self.character:getInventory():contains(self.thread)
        and self.character:getInventory():contains(self.scalpel)
end

function StitchCutWoundAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function StitchCutWoundAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    self.needle:setJobDelta(self:getJobDelta())
    self.thread:setJobDelta(self:getJobDelta())
    self.scalpel:setJobDelta(self:getJobDelta())

    self.needle:setJobType(self.jobType)
    self.thread:setJobType(self.jobType)
    self.scalpel:setJobType(self.jobType)

    if self.cleaningItem ~= nil then
        self.cleaningItem:setJobDelta(0.0)
        self.cleaningItem:setJobType(self.jobType)
    end

    if self.sutureNeedleHolder ~= nil then
        self.sutureNeedleHolder:setJobDelta(0.0)
        self.sutureNeedleHolder:setJobDelta(self:getJobDelta())
    end

    if self.glove ~= nil then
        self.glove:setJobDelta(0.0)
        self.glove:setJobDelta(self:getJobDelta())
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { stitch = true })

    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function StitchCutWoundAction:start()
    self.needle:setJobDelta(0.0)
    self.thread:setJobDelta(0.0)
    self.scalpel:setJobDelta(0.0)

    self.needle:setJobType(self.jobType)
    self.thread:setJobType(self.jobType)
    self.scalpel:setJobType(self.jobType)

    if self.sutureNeedleHolder ~= nil then
        self.sutureNeedleHolder:setJobDelta(0.0)
        self.sutureNeedleHolder:setJobType(self.jobType)
    end

    if self.glove ~= nil then
        self.glove:setJobDelta(0.0)
        self.glove:setJobType(self.jobType)
    end

    if self.cleaningItem ~= nil then
        self.cleaningItem:setJobDelta(0.0)
        self.cleaningItem:setJobType(self.jobType)
        self.cleaningItem:Use()
    end

    for _, bodyPart in ipairs({ BodyPartType.Hand_R, BodyPartType.Hand_L, BodyPartType.ForeArm_R, BodyPartType.ForeArm_L }) do
        local bloodBodyPart = BloodBodyPartType.FromIndex(BodyPartType.ToIndex(bodyPart))
        if self.character:getHumanVisual():getBlood(bloodBodyPart) > 0 and self.cleaningItem ~= nil and round(self.cleaningItem:getDrainableUsesFloat()) > 0 then
            self.cleaningItem:Use()
            self.character:getHumanVisual():setBlood(bloodBodyPart, 0)
        end
    end

    if self.cleaningItem ~= nil and round(self.cleaningItem:getDrainableUsesFloat()) > 0 and self.scalpel:getBloodLevel() > 0 then
        self.cleaningItem:Use()
        self.scalpel:setBloodLevel(0)
    end

    if self.cleaningItem ~= nil and round(self.cleaningItem:getDrainableUsesFloat()) > 0 and self.glove ~= nil and self.glove:getBloodLevel() > 0 then
        self.cleaningItem:Use()
        self.glove:setBloodLevel(0)
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

    self:setOverrideHandModels(nil, nil)
end

function StitchCutWoundAction:stop()
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)

    self.needle:setJobDelta(0.0)
    self.thread:setJobDelta(0.0)
    self.scalpel:setJobDelta(0.0)

    if self.sutureNeedleHolder ~= nil then
        self.sutureNeedleHolder:setJobDelta(0.0)
    end

    if self.cleaningItem ~= nil then
        self.cleaningItem:setJobDelta(0.0)
    end

    if self.glove ~= nil then
        self.glove:setJobDelta(0.0)
    end
end

function StitchCutWoundAction:perform()
    ISBaseTimedAction.perform(self)

    self.needle:setJobDelta(0.0)
    self.thread:setJobDelta(0.0)
    self.scalpel:setJobDelta(0.0)

    if self.sutureNeedleHolder ~= nil then
        self.sutureNeedleHolder:setJobDelta(0.0)
    end

    if self.cleaningItem ~= nil then
        self.cleaningItem:setJobDelta(0.0)
    end

    if self.glove ~= nil then
        self.glove:setJobDelta(0.0)
    end

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
    end

    self.thread:Use()

    if self.bodyPart:isGetStitchXp() then
        self.character:getXp():AddXP(Perks.Doctor, 20)
    end

    local pain = 35 - self.doctorLevel
    if self.character:HasTrait(HighPainThreshold.alias) or self.character:HasTrait(OpioidAddictionTrait.alias) then
        pain = pain * 0.75
    elseif self.character:HasTrait(LowPainThreshold.alias) then
        pain = pain * 1.25
    end

    self.bodyPart:setAdditionalPain(self.bodyPart:getAdditionalPain() + pain)
    self.bodyPart:setCut(false)
    self.bodyPart:setCutTime(0)
    self.bodyPart:setStitched(true)
    self.bodyPart:setStitchTime(((1 + self.doctorLevel) / 2) * ZombRandFloat(2.0, 5.0))

    local chanceToAvoidInfection = 5 + self.doctorLevel * 5.5
    if self.sutureNeedleHolder ~= nil or (self.needle ~= nil and self.needle:getFullType() == 'Base.SutureNeedle') then
        chanceToAvoidInfection = chanceToAvoidInfection + 10
    end

    if self.scalpel:getBloodLevel() > 0 then
        chanceToAvoidInfection = chanceToAvoidInfection - 10
    end

    if self.glove ~= nil then
        chanceToAvoidInfection = chanceToAvoidInfection + 15
        if self.glove:getBloodLevel() > 0 then
            chanceToAvoidInfection = chanceToAvoidInfection - 10
        end
    end

    for _, bodyPart in ipairs({ BodyPartType.Hand_R, BodyPartType.Hand_L, BodyPartType.ForeArm_R, BodyPartType.ForeArm_L }) do
        if self.character:getHumanVisual():getBlood(BloodBodyPartType.FromIndex(BodyPartType.ToIndex(bodyPart))) then
            chanceToAvoidInfection = chanceToAvoidInfection - 2.5
        end
    end

    if self.cleaningItem ~= nil then
        chanceToAvoidInfection = chanceToAvoidInfection - 10
    end

    if chanceToAvoidInfection < 0 then
        chanceToAvoidInfection = 0
    end

    if ZombRand(round(chanceToAvoidInfection)) == 1 then
        self.bodyPart:setInfectedWound(true)

        if isClient() then
            sendWoundInfection(self.otherPlayer:getOnlineID(), self.bodyPart:getIndex(), true)
        end
    end

    if isClient() then
        local args = { doctorOnlineId = self.character:getOnlineID(), patientOnlineId = self.otherPlayer:getOnlineID(), bodyPartIndex = self.bodyPart:getIndex(), isToggled = false, lacerationTime = 0 }
        sendClientCommand(self.character, 'surgery', SendLaceration.defaultName, args)
        sendStitch(self.otherPlayer:getOnlineID(), self.bodyPart:getIndex(), true, self.bodyPart:getStitchTime())

        if self.doctor:getAccessLevel() ~= 'None' then
            sendAdditionalPain(self.otherPlayer:getOnlineID(), self.bodyPart:getIndex(), pain)
        end
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

---@return StitchCutWoundAction
function StitchCutWoundAction:new(doctor, patient, needle, bodyPart, thread, cleaningItem, scalpel, sutureNeedleHolder, glove)
    ---@class StitchCutWoundAction
    local public = {}
    setmetatable(public, self)
    self.__index = self

    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.needle = needle
    public.thread = thread
    public.cleaningItem = cleaningItem
    public.scalpel = scalpel
    public.sutureNeedleHolder = sutureNeedleHolder
    public.glove = glove
    public.bodyPart = bodyPart
    public.doctor = doctor
    public.stopOnWalk = true
    public.stopOnRun = true
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.jobType = getText('UI_ContextMenu_RinseWoundTrimEdgesStitch')
    public.maxTime = 400

    if sutureNeedleHolder ~= nil or (needle ~= nil and needle:getFullType() == 'Base.SutureNeedle') then
        public.maxTime = 325
    end

    public.maxTime = public.maxTime - (public.doctorLevel * 4)
    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end
    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    return public
end
