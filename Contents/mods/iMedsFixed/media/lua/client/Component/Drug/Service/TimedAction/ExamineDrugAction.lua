require 'TimedActions/ISBaseTimedAction'
require 'Component/Drug/Service/Window/ExamineDrugWindow'

ExamineDrugAction = {}
ExamineDrugAction = ISBaseTimedAction:derive('ExamineDrugAction')

function ExamineDrugAction:isValid()
    return self.character:getInventory():contains(self.item)
end

function ExamineDrugAction:update()
    if self.item then
        self.item:setJobDelta(self:getJobDelta())
    end
end

function ExamineDrugAction:start()
    if self.item then
        self.item:setJobType(self.jobType)
        self.item:setJobDelta(0.0)
    end

    self:setActionAnim('Loot')
    self.character:SetVariable('LootPosition', 'Mid')
    self.character:reportEvent("EventLootItem")

    self:setOverrideHandModels(self.item, nil)
end

function ExamineDrugAction:stop()
    if self.item then
        self.item:setJobDelta(0.0)
    end

    ISBaseTimedAction.stop(self)
end

function ExamineDrugAction:perform()
    ISBaseTimedAction.perform(self)
    if self.item then
        self.item:setJobDelta(0.0)
    end

    ---@type DrugStorage
    local drugStorage = ZCore:getContainer():get('imeds.drug.storage.drug_storage')
    local drug = drugStorage:getByFullType(string.gsub(self.item:getFullType(), 'Pack', ''))

    if drug ~= nil then
        ExamineDrugWindow:showDrugInfo(drug, self.character)
        ExamineDrugWindow:setVisible(true)
    end
end

function ExamineDrugAction:new(player, item)
    local public = {}
    setmetatable(public, self)
    self.__index = self
    public.character = player
    public.item = item
    public.maxTime = 10
    public.jobType = 'ExamineDrugAction'

    if player:isTimedActionInstant() then
        public.maxTime = 1
    end

    return public
end

return ExamineDrugAction