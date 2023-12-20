require 'ISUI/ISPanel'
require 'ISUI/ISRichTextPanel'
require 'ISUI/ISButton'

--TODO ISRadioWindow / RWMPower / ISRadioAction / DeviceInspector
BloodPressureMonitorMenu = ISPanel:derive('BloodPressureMonitorMenu')

local defaultPadding = 6
local opacity = 0.2
local isPinned = false
local isDragged = false
local bigIndicatorPosition = {
    { x = 1, y = 0, width = 17, height = 4 },
    { x = 15, y = 3, width = 4, height = 15 },
    { x = 15, y = 21, width = 4, height = 15 },
    { x = 1, y = 34, width = 17, height = 4 },
    { x = 0, y = 21, width = 4, height = 15 },
    { x = 0, y = 3, width = 4, height = 15 },
    { x = 2, y = 17, width = 15, height = 5 },
}
local smallIndicatorPosition = {
    { x = 1, y = 0, width = 7, height = 2 },
    { x = 7, y = 1, width = 2, height = 8 },
    { x = 7, y = 10, width = 2, height = 8 },
    { x = 1, y = 16, width = 7, height = 2 },
    { x = 0, y = 10, width = 2, height = 8 },
    { x = 0, y = 1, width = 2, height = 8 },
    { x = 1, y = 8, width = 7, height = 3 },
}

--[[
    1
  6   2
    7
  5   3
    4
]]
local segmentsByNumber = {
    { 2, 3 },
    { 1, 2, 4, 5, 7 },
    { 1, 2, 3, 4, 7 },
    { 2, 3, 6, 7 },
    { 1, 3, 4, 6, 7 },
    { 1, 3, 4, 5, 6, 7 },
    { 1, 2, 3 },
    { 1, 2, 3, 4, 5, 6, 7 },
    { 1, 2, 3, 4, 6, 7 },
}
segmentsByNumber[0] = { 1, 2, 3, 4, 5, 6 }
local bigIndicatorWidth = 19
local bigIndicatorHeight = 38
local bigIndicatorRowWidth = 61
local bigIndicatorRowHeight = 38
local smallIndicatorWidth = 9
local smallIndicatorHeight = 18
local smallIndicatorRowWidth = 29
local smallIndicatorRowHeight = 18

function BloodPressureMonitorMenu:initialise()
    ISPanel.initialise(self)
end

function BloodPressureMonitorMenu:render()
    if not Survivor:isInitialized() then
        return false
    end

    if isDragged then
        self:setX(getMouseX() - self.dragPanel:getWidth() / 2)
        self:setY(getMouseY() - self.dragPanel:getHeight() / 2)
    end

    self.backgroundColor.a = opacity
    self.systolicRow.backgroundColor.a = opacity
    self.diastolicRow.backgroundColor.a = opacity
    self.pulseRow.backgroundColor.a = opacity
    self.displayBackground.backgroundColor.a = opacity
    self.display.backgroundColor.a = opacity

    for i = 1, 3 do
        self.systolicRow.indicators[i].backgroundColor.a = opacity
        self.systolicRow.indicators[i].borderColor.a = opacity
        for j = 1, 7 do
            self.systolicRow.indicators[i].segments[j].backgroundColor.a = opacity
            self.systolicRow.indicators[i].segments[j].borderColor.a = opacity
        end
    end

    for i = 1, 3 do
        self.diastolicRow.indicators[i].backgroundColor.a = opacity
        self.diastolicRow.indicators[i].borderColor.a = opacity
        for j = 1, 7 do
            self.diastolicRow.indicators[i].segments[j].backgroundColor.a = opacity
            self.diastolicRow.indicators[i].segments[j].borderColor.a = opacity
        end
    end

    for i = 1, 3 do
        self.pulseRow.indicators[i].backgroundColor.a = opacity
        self.pulseRow.indicators[i].borderColor.a = opacity
        for j = 1, 7 do
            self.pulseRow.indicators[i].segments[j].backgroundColor.a = opacity
            self.pulseRow.indicators[i].segments[j].borderColor.a = opacity
        end
    end
end

function BloodPressureMonitorMenu:onMouseMove(x, y)
    opacity = 1
end

function BloodPressureMonitorMenu:onMouseMoveOutside(x, y)
    if not isPinned then
        opacity = 0.2
    end
end

function BloodPressureMonitorMenu:onPinClicked(x, y)
    isPinned = not isPinned
end

function BloodPressureMonitorMenu:onDragClicked(x, y)
    isDragged = not isDragged
end

---@return BloodPressureMonitorMenu
function BloodPressureMonitorMenu:new(positionX, positionY, width, height)
    ---@class BloodPressureMonitorMenu
    local public = {}

    public = ISPanel:new(positionX, positionY, width, height)
    setmetatable(public, self)
    self.__index = self
    public.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    public.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    public:noBackground()
    public.onMouseMove = BloodPressureMonitorMenu.onMouseMove
    public.onMouseMoveOutside = BloodPressureMonitorMenu.onMouseMoveOutside
    public.positionX = positionX
    public.positionY = positionY
    public.width = width
    public.height = height

    return public
end

function BloodPressureMonitorMenu:addSystolicRow()
    self.systolicRow = ISPanel:new(46, 18, bigIndicatorRowWidth, bigIndicatorRowHeight)
    self.systolicRow.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.systolicRow.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    self.systolicRow:initialise()
    self.systolicRow.indicators = {}
    self.displayBackground:addChild(self.systolicRow)

    local bigIndicatorPositionX = 0
    for i = 1, 3 do
        self.systolicRow.indicators[i] = ISPanel:new(bigIndicatorPositionX, 0, bigIndicatorWidth, bigIndicatorHeight)
        self.systolicRow.indicators[i].backgroundColor = { r = 146 / 255, g = 155 / 255, b = 152 / 255, a = 1 }
        self.systolicRow.indicators[i].borderColor = { r = 146 / 255, g = 155 / 255, b = 152 / 255, a = 1 }
        self.systolicRow.indicators[i]:initialise()
        self.systolicRow.indicators[i].segments = {}
        self.systolicRow:addChild(self.systolicRow.indicators[i])

        for j = 1, 7 do
            self.systolicRow.indicators[i].segments[j] = ISPanel:new(bigIndicatorPosition[j].x, bigIndicatorPosition[j].y, bigIndicatorPosition[j].width, bigIndicatorPosition[j].height)
            self.systolicRow.indicators[i].segments[j].backgroundColor = { r = 0, g = 0, b = 0, a = 1 }
            self.systolicRow.indicators[i].segments[j].borderColor = { r = 0, g = 0, b = 0, a = 1 }
            self.systolicRow.indicators[i].segments[j]:initialise()
            self.systolicRow.indicators[i].segments[j]:setVisible(false)
            self.systolicRow.indicators[i]:addChild(self.systolicRow.indicators[i].segments[j])
        end

        bigIndicatorPositionX = bigIndicatorPositionX + bigIndicatorWidth + 2
    end
end

function BloodPressureMonitorMenu:addDiastolicRow()
    self.diastolicRow = ISPanel:new(46, 62, bigIndicatorRowWidth, bigIndicatorRowHeight)
    self.diastolicRow.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    self.diastolicRow.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.diastolicRow:initialise()
    self.diastolicRow.indicators = {}
    self.displayBackground:addChild(self.diastolicRow)

    local bigIndicatorPositionX = 0
    for i = 1, 3 do
        self.diastolicRow.indicators[i] = ISPanel:new(bigIndicatorPositionX, 0, bigIndicatorWidth, bigIndicatorHeight)
        self.diastolicRow.indicators[i].backgroundColor = { r = 146 / 255, g = 155 / 255, b = 152 / 255, a = 1 }
        self.diastolicRow.indicators[i].borderColor = { r = 146 / 255, g = 155 / 255, b = 152 / 255, a = 1 }
        self.diastolicRow.indicators[i]:initialise()
        self.diastolicRow.indicators[i].segments = {}
        self.diastolicRow:addChild(self.diastolicRow.indicators[i])

        for j = 1, 7 do
            self.diastolicRow.indicators[i].segments[j] = ISPanel:new(bigIndicatorPosition[j].x, bigIndicatorPosition[j].y, bigIndicatorPosition[j].width, bigIndicatorPosition[j].height)
            self.diastolicRow.indicators[i].segments[j].backgroundColor = { r = 0, g = 0, b = 0, a = 1 }
            self.diastolicRow.indicators[i].segments[j].borderColor = { r = 0, g = 0, b = 0, a = 1 }
            self.diastolicRow.indicators[i].segments[j]:initialise()
            self.diastolicRow.indicators[i].segments[j]:setVisible(false)
            self.diastolicRow.indicators[i]:addChild(self.diastolicRow.indicators[i].segments[j])
        end

        bigIndicatorPositionX = bigIndicatorPositionX + bigIndicatorWidth + 2
    end
end

function BloodPressureMonitorMenu:addPulseRow()
    self.pulseRow = ISPanel:new(74, 103, smallIndicatorRowWidth, smallIndicatorRowHeight)
    self.pulseRow.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    self.pulseRow.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    self.pulseRow:initialise()
    self.pulseRow.indicators = {}
    self.displayBackground:addChild(self.pulseRow)

    local smallIndicatorPositionX = 0
    for i = 1, 3 do
        self.pulseRow.indicators[i] = ISPanel:new(smallIndicatorPositionX, 0, smallIndicatorWidth, smallIndicatorHeight)
        self.pulseRow.indicators[i].backgroundColor = { r = 146 / 255, g = 155 / 255, b = 152 / 255, a = 1 }
        self.pulseRow.indicators[i].borderColor = { r = 146 / 255, g = 155 / 255, b = 152 / 255, a = 1 }
        self.pulseRow.indicators[i]:initialise()
        self.pulseRow.indicators[i].segments = {}
        self.pulseRow:addChild(self.pulseRow.indicators[i])

        for j = 1, 7 do
            self.pulseRow.indicators[i].segments[j] = ISPanel:new(smallIndicatorPosition[j].x, smallIndicatorPosition[j].y, smallIndicatorPosition[j].width, smallIndicatorPosition[j].height)
            self.pulseRow.indicators[i].segments[j].backgroundColor = { r = 0, g = 0, b = 0, a = 1 }
            self.pulseRow.indicators[i].segments[j].borderColor = { r = 0, g = 0, b = 0, a = 1 }
            self.pulseRow.indicators[i].segments[j]:initialise()
            self.pulseRow.indicators[i].segments[j]:setVisible(false)
            self.pulseRow.indicators[i]:addChild(self.pulseRow.indicators[i].segments[j])
        end

        smallIndicatorPositionX = smallIndicatorPositionX + smallIndicatorWidth + 1
    end
end

function BloodPressureMonitorMenu:show()
    local width = 150
    local height = 200
    local rightPadding = 81 + defaultPadding * 2
    local topPadding = 100

    local menu = self:new(getCore():getScreenWidth() - rightPadding - width, topPadding, width, height)
    menu:addToUIManager()
    menu:setVisible(true)

    local displayBackgroundWidth = 112
    local displayBackgroundHeight = 128
    menu.displayBackground = ISPanel:new(19, 21, displayBackgroundWidth, displayBackgroundHeight)
    menu.displayBackground.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    menu.displayBackground.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    menu.displayBackground:initialise()
    menu:addChild(menu.displayBackground)

    self.addSystolicRow(menu)
    self.addDiastolicRow(menu)
    self.addPulseRow(menu)

    menu.display = ISImage:new(0, 0, width, height, getTexture('media/ui/BloodPressureMonitor/Display.png'))
    menu.display:initialise()
    menu:addChild(menu.display)

    local buttonPositionX = 7
    local buttonPositionY = 153
    local buttonWidth = 138
    local buttonHeight = 34

    menu.display.button = ISButton:new(buttonPositionX, buttonPositionY, buttonWidth, buttonHeight, '', menu, self.checkBloodPressure)
    menu.display.button.internal = 'On/Off'
    menu.display.button.anchorLeft = false
    menu.display.button.anchorRight = true
    menu.display.button.anchorTop = false
    menu.display.button.anchorBottom = true
    menu.display.button:initialise()
    menu.display.button:instantiate()
    menu.display.button.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    menu.display.button.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    menu.display.button.backgroundColorMouseOver.a = 0
    menu.display:addChild(menu.display.button)



    menu.dragPanel = ISPanel:new(0, 0, menu:getWidth(), 19)
    menu.dragPanel.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    menu.dragPanel.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    menu.dragPanel.onMouseDown = self.onDragClicked
    menu.dragPanel:initialise()
    menu:addChild(menu.dragPanel)

    self.instance = menu
    self = menu
end

local isEnabled = false
function BloodPressureMonitorMenu:checkBloodPressure()
    if not isEnabled then
        local bodyPart = getSpecificPlayer(0):getBodyDamage():getBodyPart(BodyPart.Hand_R)
        if BloodPressureMonitorMenu.instance.wristMonitor:getFullType() == BloodPressureMonitorLeft.fullType then
            bodyPart = getSpecificPlayer(0):getBodyDamage():getBodyPart(BodyPart.Hand_L)
        end

        ISTimedActionQueue.add(CheckBloodPressureAction:new(getSpecificPlayer(0), getSpecificPlayer(0), BloodPressureMonitorMenu.instance.wristMonitor, bodyPart))
    else
        self:resetSystolicIndicators()
        self:resetDiastolicIndicators()
        self:resetPulseIndicators()
    end

    isEnabled = not isEnabled
end

function BloodPressureMonitorMenu:disable()
    BloodPressureMonitorMenu.instance:removeFromUIManager()
    BloodPressureMonitorMenu.instance = nil
end

function BloodPressureMonitorMenu:resize(oldWidth, oldHeight, newWidth, newHeight)
    self:disable()
    self:show()
end

function BloodPressureMonitorMenu:getDigitsFromNumber(number)
    number = tostring(round(number))

    local values = {}
    if string.len(number) == 3 then
        values[1], values[2], values[3] = string.match(number, '(%d+)(%d+)(%d+)')
    else
        values[1] = nil
        values[2], values[3] = string.match(number, '(%d+)(%d+)')
    end

    return values
end

function BloodPressureMonitorMenu:updateSystolicBloodPressure()
    self:resetSystolicIndicators()
    local digits = self:getDigitsFromNumber(Survivor:getBlood():getPressure():getSystolic())
    for i = 3, 1, -1 do
        if digits[i] ~= nil then
            for _, segmentId in ipairs(segmentsByNumber[tonumber(digits[i])]) do
                self.instance.systolicRow.indicators[i].segments[segmentId]:setVisible(true)
            end
        end
    end
end

function BloodPressureMonitorMenu:updateDiastolicBloodPressure()
    self:resetDiastolicIndicators()
    local digits = self:getDigitsFromNumber(Survivor:getBlood():getPressure():getDiastolic())
    for i = 3, 1, -1 do
        if digits[i] ~= nil then
            for _, segmentId in ipairs(segmentsByNumber[tonumber(digits[i])]) do
                self.instance.diastolicRow.indicators[i].segments[segmentId]:setVisible(true)
            end
        end
    end
end

function BloodPressureMonitorMenu:updatePulse()
    self:resetPulseIndicators()
    local digits = self:getDigitsFromNumber(Survivor:getBlood():getPulse())
    for i = 3, 1, -1 do
        if digits[i] ~= nil then
            for _, segmentId in ipairs(segmentsByNumber[tonumber(digits[i])]) do
                self.instance.pulseRow.indicators[i].segments[segmentId]:setVisible(true)
            end
        end
    end
end

function BloodPressureMonitorMenu:resetSystolicIndicators()
    for i = 1, 3 do
        for j = 1, 7 do
            self.instance.systolicRow.indicators[i].segments[j]:setVisible(false)
        end
    end
end

function BloodPressureMonitorMenu:resetDiastolicIndicators()
    for i = 1, 3 do
        for j = 1, 7 do
            self.instance.diastolicRow.indicators[i].segments[j]:setVisible(false)
        end
    end
end

function BloodPressureMonitorMenu:resetPulseIndicators()
    for i = 1, 3 do
        for j = 1, 7 do
            self.instance.pulseRow.indicators[i].segments[j]:setVisible(false)
        end
    end
end

function BloodPressureMonitorMenu:getEquippedWrist()
    local wrist
    for i = 0, getSpecificPlayer(0):getInventory():getItems():size() - 1 do
        local item = getSpecificPlayer(0):getInventory():getItems():get(i)
        if in_table(item:getFullType(), { BloodPressureMonitorRight.fullType, BloodPressureMonitorLeft.fullType }) and getSpecificPlayer(0):isEquipped(item) then
            wrist = item
        end
    end

    return wrist
end

function BloodPressureMonitorMenu:updateUI()
    if self:getEquippedWrist() == nil then
        if self.instance ~= nil then
            self:disable()
        end

        return false
    end

    if self.instance == nil then
        self:show()
        self.instance.wristMonitor = self:getEquippedWrist()
    end
end

Events[ImmersiveMedicineEvent.iMedsSurvivorCreated].Add(function(module)
    if module == 'Moodle' then
        Events.OnResolutionChange.Add(BloodPressureMonitorMenu.resize)
        Events.OnTick.Add(function()
            if Survivor:isDeadOrNotExist() or not Survivor:isInitialized() then
                if BloodPressureMonitorMenu.instance ~= nil then
                    BloodPressureMonitorMenu:disable()
                end

                return false
            end

            BloodPressureMonitorMenu:updateUI()
        end)
    end
end)
