---@class Blood
Blood = {}

Blood.maxVolume = 5000
Blood.minVolume = 2000

Blood.pulse = {
    min = 5,
    normal = 60,
    max = 160,
}

Blood.algoverBurryShockIndex = {
    [0] = { threshold = 0.5, 0 },
    [1] = { threshold = 0.8, 0.15, 0.20}, -- 15-20%
    [2] = { threshold = 1, 0.2, 0.4 }, -- 20-40%
    [3] = { threshold = 1.3, 0.4, 0.5 }, -- >40%
}

---@return number
function Blood:getVolume()
    return getSpecificPlayer(0):getModData().survivor.blood.volume
end

---@param value number
---@return void
function Blood:setVolume(value)
    getSpecificPlayer(0):getModData().survivor.blood.volume = value
end

---@param value number
---@return void
function Blood:addVolume(value)
    getSpecificPlayer(0):getModData().survivor.blood.volume = getSpecificPlayer(0):getModData().survivor.blood.volume + value
end

---@param value number
---@return void
function Blood:reduceVolume(value)
    getSpecificPlayer(0):getModData().survivor.blood.volume = getSpecificPlayer(0):getModData().survivor.blood.volume - value
end

---@return BloodGroup
function Blood:getGroup()
    ---@type BloodGroupStorage
    local bloodGroupStorage = ZCore:getContainer():get('imeds.blood.storage.blood_group_storage')

    return bloodGroupStorage:getById(getSpecificPlayer(0):getModData().survivor.blood.group)
end

---@param id number
---@return void
function Blood:setGroup(id)
    getSpecificPlayer(0):getModData().survivor.blood.group = id
end

---@return table<string, table>
function Blood:getDrugs()
    return getSpecificPlayer(0):getModData().survivor.blood.drugs or {}
end

---@param drug Drug
---@param dosageForm string
---@param dose number
---@return void
function Blood:addDrug(drug, dosageForm, dose)
    if getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()] == nil then
        getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()] = {}

        getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].maxDose = drug:getMaxDose()
        getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].dose = 0
        getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].duration = 0
        getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].onset = 0
    end

    getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].dose = getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].dose + dose
    for _ = 1, dose do
        local onset = drug:getOnsetByDosageForm(dosageForm) * TimeHandler.onset
        local duration = drug:getDurationByDosageForm(dosageForm) * TimeHandler.durationModifier
        if getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].dose > 1 then
            duration = duration / 2
            onset = 0
        end

        getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].onset = getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].onset + round10(onset)
        getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].duration = getSpecificPlayer(0):getModData().survivor.blood.drugs[drug:getAlias()].duration + round10(duration)
    end
end

---@return number
function Blood:getOpiatePoisonLevel()
    if getSpecificPlayer(0):getModData().survivor.blood.opiatePoisonLevel == nil then
        getSpecificPlayer(0):getModData().survivor.blood.opiatePoisonLevel = 0
    end

    return getSpecificPlayer(0):getModData().survivor.blood.opiatePoisonLevel
end

---@return void
---@param value number
function Blood:setOpiatePoisonLevel(value)
    getSpecificPlayer(0):getModData().survivor.blood.opiatePoisonLevel = value
end

---@return BloodPressure
function Blood:getPressure()
    if getSpecificPlayer(0):getModData().survivor.blood.pressure == nil then
        getSpecificPlayer(0):getModData().survivor.blood.pressure = {}
    end

    return require 'Component/Blood/Entity/BloodPressure'
end

---@return number
function Blood:getPulse()
    if getSpecificPlayer(0):getModData().survivor.blood.pulse == nil then
        getSpecificPlayer(0):getModData().survivor.blood.pulse = 0
    end

    return getSpecificPlayer(0):getModData().survivor.blood.pulse
end

---@param value number
---@return nil
function Blood:setPulse(value)
    getSpecificPlayer(0):getModData().survivor.blood.pulse = value
end

---@param pulse number
---@return number
function Blood:getHeartbeatDelta(pulse)
    return round(10800 / pulse)
end

---@return table<string, number|nil>
function Blood:getBloodLossVolume()
    local value = round(self:getPulse() / self:getPressure():getSystolic() + 0.05, 1)
    local shockDegreeResult = 0
    for shockDegree, data in pairs(self.algoverBurryShockIndex) do
        if value >= data.threshold then
            shockDegreeResult = shockDegree
        end
    end

    local fromVolume = 0
    local toVolume
    if shockDegreeResult > 0 and shockDegreeResult < 3 then
        fromVolume = Blood.maxVolume * Blood.algoverBurryShockIndex[shockDegreeResult][1]
        toVolume = Blood.maxVolume * Blood.algoverBurryShockIndex[shockDegreeResult][2]
    elseif shockDegreeResult == 3 then
        fromVolume = Blood.maxVolume * Blood.algoverBurryShockIndex[shockDegreeResult][1]
    end

    return {
        from = fromVolume,
        to = toVolume,
    }
end

return Blood