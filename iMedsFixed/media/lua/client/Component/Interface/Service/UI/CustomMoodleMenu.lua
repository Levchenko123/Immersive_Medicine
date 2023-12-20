require 'ISUI/ISPanel'
require 'ISUI/ISRichTextPanel'
require 'ISUI/ISButton'

CustomMoodleMenu = ISPanel:derive('CustomMoodleMenu')

local defaultPadding = 6
local opacity = 0.2

function CustomMoodleMenu:initialise()
    ISPanel.initialise(self)
end

function CustomMoodleMenu:render()
    if not Survivor:isInitialized() then
        return false
    end

    local y = 1
    for _, moodle in pairs(self.moodles) do
        local sideEffect = Survivor:getSideEffects()[moodle:getSideEffect():getAlias()]
        if sideEffect ~= nil then
            local level = sideEffect.level
            if self.activeMoodles[moodle:getAlias()] == nil then
                self.activeMoodles[moodle:getAlias()] = ISImage:new(0, 0, 31, 30, nil)
                self.activeMoodles[moodle:getAlias()]:initialise()
                self.activeMoodles[moodle:getAlias()].parent = self
                self:addChild(self.activeMoodles[moodle:getAlias()])
            end

            if level > 0 and level <= moodle:getSideEffect():getMaxLevel() then
                self.activeMoodles[moodle:getAlias()].texture = moodle:getTextureByLevel(level)
                self.activeMoodles[moodle:getAlias()]:setMouseOverText(moodle:getSideEffect():getDescriptionByLevel(level))
            end

            self.activeMoodles[moodle:getAlias()]:setVisible(sideEffect.isActive)
            self.activeMoodles[moodle:getAlias()].backgroundColor.a = opacity

            if sideEffect.isActive then
                self.activeMoodles[moodle:getAlias()]:setY(y)
                y = y + 30 + defaultPadding
            end
        end
    end
end

function CustomMoodleMenu:onMouseMove(x, y)
    opacity = 1
end

function CustomMoodleMenu:onMouseMoveOutside(x, y)
    opacity = 0.2
end

---@return CustomMoodleMenu
function CustomMoodleMenu:new(positionX, positionY, width, height)
    ---@class CustomMoodleMenu
    local public = {}

    public = ISPanel:new(positionX, positionY, width, height)
    setmetatable(public, self)
    self.__index = self
    public.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    public.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    public.onMouseMove = CustomMoodleMenu.onMouseMove
    public.onMouseMoveOutside = CustomMoodleMenu.onMouseMoveOutside
    public.positionX = positionX
    public.positionY = positionY
    public.width = width
    public.height = height
    ---@type Moodle[]
    public.moodles = ZCore:getContainer():get('imeds.moodle.storage.moodle_storage'):findAll()
    public.activeMoodles = {}
    public.resizable = false

    CustomMoodleMenu.instance = public

    return public
end

function CustomMoodleMenu:show()
    local width = 31
    local height = 30 * 10
    local rightPadding = 19 + defaultPadding + width
    local topPadding = 100

    local menu = CustomMoodleMenu:new(getCore():getScreenWidth() - rightPadding - width, topPadding, width, height)
    menu:addToUIManager()
    menu:setVisible(true)
end

function CustomMoodleMenu:resize(oldWidth, oldHeight, newWidth, newHeight)
    CustomMoodleMenu.instance:removeFromUIManager()
    CustomMoodleMenu.instance = nil

    CustomMoodleMenu:show()
end

function CustomMoodleMenu:disable()
    CustomMoodleMenu.instance:removeFromUIManager()
    CustomMoodleMenu.instance = nil
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Moodle' then
        CustomMoodleMenu.show()
        Events.OnResolutionChange.Add(CustomMoodleMenu.resize)
    end
end)
