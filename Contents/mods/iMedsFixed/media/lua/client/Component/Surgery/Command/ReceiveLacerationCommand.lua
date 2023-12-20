---@class ReceiveLaceration
ReceiveLaceration = {
    defaultName = 'receiveLaceration',
}

if not isClient() then
    return
end

ReceiveLaceration.execute = function(package)
    local doctor = getPlayerByOnlineID(package.doctorOnlineId)
    local patient = getPlayerByOnlineID(package.patientOnlineId)
    local isToggled = package.isToggled
    local lacerationTime = package.lacerationTime
    local bodyPart = BodyPartType.FromIndex(package.bodyPartIndex)

    if doctor ~= nil and patient ~= nil then
        getSpecificPlayer(0):getBodyDamage():getBodyPart(bodyPart):setCut(isToggled)
        getSpecificPlayer(0):getBodyDamage():getBodyPart(bodyPart):setCutTime(lacerationTime)
    end
end

Events.OnServerCommand.Add(
    function(module, command, package)
        if module == 'surgery' and command == ReceiveLaceration.defaultName then
            ReceiveLaceration.execute(package)
        end
    end
)
