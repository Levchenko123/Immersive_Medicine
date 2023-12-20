SurvivorCreator = {}

---@return SurvivorCreator
function SurvivorCreator:new(bloodGroupStorage)
    ---@class SurvivorCreator
    local public = {}
    local private = {}

    ---@type BloodGroupStorage
    private.bloodGroupStorage = bloodGroupStorage

    function public:create()
        getSpecificPlayer(0):getModData().survivor = {
            isInitialized = false,
        }
        getSpecificPlayer(0):getModData().survivor.blood = {}
        getSpecificPlayer(0):getModData().survivor.blood.drugs = {}
        getSpecificPlayer(0):getModData().survivor.blood.opiatePoisonLevel = 0

        getSpecificPlayer(0):getModData().survivor.isKnowOwnBloodGroup = false
        getSpecificPlayer(0):getModData().survivor.stressFromOpioidAddiction = 0

        getSpecificPlayer(0):getModData().survivor.sideEffects = {}

        getSpecificPlayer(0):getModData().survivor.blood.pressure = {}
        getSpecificPlayer(0):getModData().survivor.blood.pressure.systolic = BloodPressure.systolic.normal
        getSpecificPlayer(0):getModData().survivor.blood.pressure.diastolic = BloodPressure.diastolic.normal

        getSpecificPlayer(0):getModData().survivor.blood.pulse = 0

        Survivor:getBlood():setVolume(Blood.maxVolume)

        local bloodGroup = private.bloodGroupStorage:getRandomBloodGroup()
        if getSpecificPlayer(0):HasTrait(UniversalDonor.alias) then
            bloodGroup = private.bloodGroupStorage:getById(BloodGroup.ON)
            Survivor:setIsKnowOwnBloodGroup(true)
        elseif getSpecificPlayer(0):HasTrait(UniversalRecipient.alias) then
            bloodGroup = private.bloodGroupStorage:getById(BloodGroup.ABP)
            Survivor:setIsKnowOwnBloodGroup(true)
        end

        Survivor:getBlood():setGroup(bloodGroup:getId())
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'SurvivorCreator'

    return public
end

return SurvivorCreator
