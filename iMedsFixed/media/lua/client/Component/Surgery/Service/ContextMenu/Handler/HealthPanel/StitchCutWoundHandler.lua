StitchCutWoundHandler = {}
local BaseHandlerProxy = require('Component/Interface/Service/ContextMenu/Proxy/BaseHandlerProxy'):new()
StitchCutWoundHandler = BaseHandlerProxy:derive('StitchCutWoundHandler')

---@return StitchCutWoundHandler
function StitchCutWoundHandler:new(panel, bodyPart)
    ---@class StitchCutWoundHandler
    local public = BaseHandlerProxy.new(self, panel, bodyPart)
    public.items.needles = {}
    public.items.threads = {}
    public.items.sutureNeedles = {}
    public.items.sutureNeedleHolders = {}
    public.items.scalpels = {}
    public.items.gloves = {}
    public.items.disinfectants = {}
    public.items.water = {}

    return public
end

function StitchCutWoundHandler:checkItem(item)
    if item:getFullType() == 'Base.Needle' then
        self:addItem(self.items.needles, item)
    end

    if item:getFullType() == 'Base.Thread' then
        self:addItem(self.items.threads, item)
    end

    if item:getFullType() == 'Base.SutureNeedle' and not item:isBroken() then
        self:addItem(self.items.sutureNeedles, item)
    end

    if item:getFullType() == 'Base.SutureNeedleHolder' then
        self:addItem(self.items.sutureNeedleHolders, item)
    end

    if item:getFullType() == 'Base.Scalpel' and not item:isBroken() then
        self:addItem(self.items.scalpels, item)
    end

    if item:getFullType() == 'Base.Gloves_Surgical' and not item:isBroken() then
        self:addItem(self.items.gloves, item)
    end

    if item:getFullType() == 'Base.Disinfectant' then
        self:addItem(self.items.disinfectants, item)
    end

    if item:isWaterSource() and Recipe.OnTest.NotTaintedWater(item) then
        self:addItem(self.items.water, item)
    end
end

function StitchCutWoundHandler:addToMenu(context)
    if not self:isInjured() or not self.bodyPart:isCut() then
        return false
    end

    table.sort(self.items.scalpels, ISWorldObjectContextMenu.compareClothingBlood)
    table.sort(self.items.gloves, ISWorldObjectContextMenu.compareClothingBlood)

    local function compareDrainableUses(item1, item2)
        return round(item1:getDrainableUsesFloat()) > round(item2:getDrainableUsesFloat())
    end

    table.sort(self.items.disinfectants, compareDrainableUses)
    table.sort(self.items.water, compareDrainableUses)

    local needle = self.items.needles[1]
    local thread = self.items.threads[1]
    local sutureNeedle = self.items.sutureNeedles[1]
    local sutureNeedleHolder = self.items.sutureNeedleHolders[1]
    local scalpel = self.items.scalpels[1]
    local glove = self.items.gloves[1]
    local water = self.items.water[1]
    local disinfectant = self.items.disinfectants[1]

    local resultNeedle
    if sutureNeedle ~= nil then
        resultNeedle = sutureNeedle
    elseif needle ~= nil then
        resultNeedle = needle
    end

    if resultNeedle == nil then
        return false
    end

    local option = context:addOption(getText('UI_ContextMenu_RinseWoundTrimEdgesStitch'), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    local subMenuOption = subMenu:addOption(resultNeedle:getName(), self, self.onMenuOptionSelected, resultNeedle, thread, water, scalpel, sutureNeedleHolder, glove, disinfectant)

    local tooltip = ISToolTip:new()
    tooltip:initialise()
    tooltip:setVisible(false)
    tooltip:setName(resultNeedle:getName())
    tooltip.description = ''

    local isAvailable = true
    local doctorPerk = PerkFactory.getPerk(Perks.Doctor)

    if self:getDoctor():getPerkLevel(Perks.Doctor) >= 4 then
        tooltip.description = tooltip.description .. ' <RGB:1,1,1> ' .. getText('IGUI_perks_' .. doctorPerk:getType():toString()) .. ' ' .. self:getDoctor():getPerkLevel(Perks.Doctor) .. '/4' .. ' <LINE>'
    else
        tooltip.description = tooltip.description .. ' <RGB:1,0,0> ' .. getText('IGUI_perks_' .. doctorPerk:getType():toString()) .. ' ' .. self:getDoctor():getPerkLevel(Perks.Doctor) .. '/4' .. ' <LINE>'
        isAvailable = false
    end

    if needle ~= nil then
        tooltip.description = tooltip.description .. ' <RGB:1,1,1> ' .. needle:getName()
    else
        tooltip.description = tooltip.description .. ' <RGB:1,1,0> ' .. getItemNameFromFullType('Base.Needle')
    end

    if sutureNeedle ~= nil then
        tooltip.description = tooltip.description .. ' ' .. '  <RGB:1,1,1> ' .. getText("ContextMenu_or") .. ' ' .. sutureNeedle:getName() .. ' <LINE> '
    else
        tooltip.description = tooltip.description .. ' ' .. '  <RGB:1,1,0> ' .. getText("ContextMenu_or") .. ' ' .. getItemNameFromFullType('Base.SutureNeedle') .. ' <LINE> '
    end

    if sutureNeedle == nil and needle == nil then
        isAvailable = false
    end

    if scalpel ~= nil then
        tooltip.description = tooltip.description .. ' <RGB:1,1,1> ' .. scalpel:getName() .. ' <LINE> '
    else
        tooltip.description = tooltip.description .. ' <RGB:1,0,0> ' .. getItemNameFromFullType('Base.Scalpel') .. ' <LINE> '
        isAvailable = false
    end

    if thread ~= nil then
        tooltip.description = tooltip.description .. ' <RGB:1,1,1> ' .. thread:getName() .. ' <LINE> '
    else
        tooltip.description = tooltip.description .. ' <RGB:1,0,0> ' .. getItemNameFromFullType('Base.Thread') .. ' <LINE> '
        isAvailable = false
    end

    if sutureNeedleHolder ~= nil then
        tooltip.description = tooltip.description .. ' <RGB:1,1,1> ' .. sutureNeedleHolder:getName() .. ' <LINE> '
    else
        tooltip.description = tooltip.description .. ' <RGB:1,1,0> ' .. getItemNameFromFullType('Base.SutureNeedleHolder') .. ' <LINE> '
    end

    if glove ~= nil then
        tooltip.description = tooltip.description .. ' <RGB:1,1,1> ' .. glove:getName() .. ' <LINE> '
    else
        tooltip.description = tooltip.description .. ' <RGB:1,1,0> ' .. getItemNameFromFullType('Base.Gloves_Surgical') .. ' <LINE> '
    end

    local waterNeeded = 1
    if scalpel ~= nil and scalpel:getBloodLevel() > 0 then
        waterNeeded = waterNeeded + 1
    end

    if glove ~= nil and glove:getBloodLevel() > 0 then
        waterNeeded = waterNeeded + 1
    end

    for _, bodyPart in ipairs({ BodyPartType.Hand_R, BodyPartType.Hand_L, BodyPartType.ForeArm_R, BodyPartType.ForeArm_L }) do
        if self:getDoctor():getHumanVisual():getBlood(BloodBodyPartType.FromIndex(BodyPartType.ToIndex(bodyPart))) > 0 then
            waterNeeded = waterNeeded + 1
        end
    end

    if water ~= nil then
        tooltip.description = tooltip.description .. ' <RGB:1,1,1> ' .. getText('ContextMenu_WaterName') .. ' ' .. round(water:getDrainableUsesFloat()) .. '/' .. waterNeeded .. ' <LINE> '
    else
        tooltip.description = tooltip.description .. ' <RGB:1,1,0> ' .. getText('ContextMenu_WaterName') .. ' 0/' .. waterNeeded
    end

    local disinfectantNeeded = waterNeeded
    if disinfectant ~= nil then
        tooltip.description = tooltip.description .. ' <RGB:1,1,1> ' .. getText("ContextMenu_or") .. ' ' .. getText('ContextMenu_WaterName') .. ' ' .. round(disinfectant:getDrainableUsesFloat()) .. '/' .. disinfectantNeeded .. ' <LINE> '
    else
        tooltip.description = tooltip.description .. ' <RGB:1,1,0> ' .. getText("ContextMenu_or") .. ' ' .. getItemNameFromFullType('Base.Disinfectant') .. ' 0/' .. disinfectantNeeded .. ' <LINE> '
    end

    subMenuOption.toolTip = tooltip
    subMenuOption.notAvailable = not isAvailable
end

function StitchCutWoundHandler:dropItems(items)
    if not self:isInjured() or not self.bodyPart:isCut() then
        return false
    end

    local needle = self:getItemOfType(self.items.needles, 'Base.Needle')
    local thread = self:getItemOfType(self.items.threads, 'Base.Thread')
    local scalpel = self:getItemOfType(self.items.scalpels, 'Base.Scalpel')
    local sutureNeedle = self:getItemOfType(self.items.sutureNeedles, 'Base.SutureNeedle')
    local sutureNeedleHolder = self:getItemOfType(self.items.sutureNeedleHolders, 'Base.SutureNeedleHolder')
    local glove = self:getItemOfType(self.items.gloves, 'Base.Gloves_Surgical')
    local water = self.items.water[1]
    local disinfectant = self.items.disinfectant[1]

    if needle == nil or scalpel == nil then
        return false
    end

    local resultNeedle
    if sutureNeedle ~= nil then
        resultNeedle = sutureNeedle
    elseif needle ~= nil then
        resultNeedle = needle
    else
        return false
    end

    self:onMenuOptionSelected(resultNeedle, thread, water, scalpel, sutureNeedleHolder, glove, disinfectant)

    return true
end

function StitchCutWoundHandler:isValid(needle, thread, water, scalpel, sutureNeedleHolder, glove, disinfectant)
    if not self:isInjured() or not self.bodyPart:isCut() then
        return false
    end

    self:checkItems()

    return needle ~= nil and thread ~= nil and scalpel ~= nil
end

function StitchCutWoundHandler:perform(previousAction, needle, thread, water, scalpel, sutureNeedleHolder, glove, disinfectant)
    previousAction = self:toPlayerInventory(needle, previousAction)
    previousAction = self:toPlayerInventory(thread, previousAction)
    previousAction = self:toPlayerInventory(scalpel, previousAction)

    if sutureNeedleHolder ~= nil then
        previousAction = self:toPlayerInventory(sutureNeedleHolder, previousAction)
    end

    local cleaningItem
    if water ~= nil then
        cleaningItem = water
    end

    if cleaningItem ~= nil and disinfectant ~= nil then
        cleaningItem = water:getDrainableUsesFloat() > disinfectant:getDrainableUsesFloat() and water or disinfectant
    end

    if cleaningItem ~= nil then
        previousAction = self:toPlayerInventory(cleaningItem, previousAction)
    end

    if glove ~= nil then
        previousAction = self:toPlayerInventory(glove, previousAction)

        local equipAction = ISWearClothing:new(self:getDoctor(), glove, 50)
        ISTimedActionQueue.addAfter(previousAction, equipAction)

        previousAction = equipAction
    end

    local action = StitchCutWoundAction:new(self:getDoctor(), self:getPatient(), needle, self.bodyPart, thread, cleaningItem, scalpel, sutureNeedleHolder, glove)
    ISTimedActionQueue.addAfter(previousAction, action)
end

ZCore:getContainer():register(
    require 'Component/Interface/Service/ContextMenu/Handler/HandlerDecorator',
    'imeds.blood.context_menu.handler.stitch_cut_wound',
    {
        StitchCutWoundHandler
    },
    'imeds.context_menu.health_panel.handler'
)