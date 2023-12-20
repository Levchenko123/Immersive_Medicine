require 'ISUI/ISPanel'
require 'ISUI/ISRichTextPanel'
require 'ISUI/ISButton'

--TODO ISRadioWindow / RWMPower / ISRadioAction / DeviceInspector
BloodPressureWindow = ISCollapsableWindow:derive('BloodPressureWindow')

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

function BloodPressureWindow:initialise()
    ISCollapsableWindow.initialise(self)
end

---@return BloodPressureWindow
function BloodPressureWindow:new(positionX, positionY, width, height)
    ---@class BloodPressureWindow
    local public = {}

    public = ISCollapsableWindow:new(positionX, positionY, width, height)
    setmetatable(public, self)
    self.__index = self
    public.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    public.backgroundColor = { r = 0, g = 0, b = 0, a = 0.3 }
    public.positionX = positionX
    public.positionY = positionY
    public.anchorBottom = true
    public.width = width
    public.height = height
    public.pin = true
    public:setResizable(false)

    return public
end

function BloodPressureWindow:addSystolicRow()
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

function BloodPressureWindow:addDiastolicRow()
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

function BloodPressureWindow:addPulseRow()
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

function BloodPressureWindow:show()
    local width = 150
    local height = 200

    local menu = self:new(300, 250, width, height + 16)
    menu:initialise()
    menu:addToUIManager()
    menu:setVisible(false)

    local displayBackgroundWidth = 112
    local displayBackgroundHeight = 128
    menu.displayBackground = ISPanel:new(19, 37, displayBackgroundWidth, displayBackgroundHeight)
    menu.displayBackground.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    menu.displayBackground.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    menu.displayBackground:initialise()
    menu:addChild(menu.displayBackground)

    self.addSystolicRow(menu)
    self.addDiastolicRow(menu)
    self.addPulseRow(menu)

    menu.display = ISImage:new(0, 16, width, height, getTexture('media/ui/BloodPressureMonitor/Display.png'))
    menu.display:initialise()
    menu.display.parent = menu
    menu:addChild(menu.display)

    self.instance = menu
    BloodPressureWindow = menu
end

function BloodPressureWindow:getDigitsFromNumber(number)
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

function BloodPressureWindow:setSystolicBloodPressure(value)
    self:resetSystolicIndicators()
    local digits = self:getDigitsFromNumber(value)
    for i = 3, 1, -1 do
        if digits[i] ~= nil then
            for _, segmentId in ipairs(segmentsByNumber[tonumber(digits[i])]) do
                self.instance.systolicRow.indicators[i].segments[segmentId]:setVisible(true)
            end
        end
    end
end

function BloodPressureWindow:setDiastolicBloodPressure(value)
    self:resetDiastolicIndicators()
    local digits = self:getDigitsFromNumber(value)
    for i = 3, 1, -1 do
        if digits[i] ~= nil then
            for _, segmentId in ipairs(segmentsByNumber[tonumber(digits[i])]) do
                self.instance.diastolicRow.indicators[i].segments[segmentId]:setVisible(true)
            end
        end
    end
end

function BloodPressureWindow:setPulse(value)
    self:resetPulseIndicators()
    local digits = self:getDigitsFromNumber(value)
    for i = 3, 1, -1 do
        if digits[i] ~= nil then
            for _, segmentId in ipairs(segmentsByNumber[tonumber(digits[i])]) do
                self.instance.pulseRow.indicators[i].segments[segmentId]:setVisible(true)
            end
        end
    end
end

function BloodPressureWindow:setPatientName(name)
    self.instance.title = name
end

function BloodPressureWindow:resetSystolicIndicators()
    for i = 1, 3 do
        for j = 1, 7 do
            self.instance.systolicRow.indicators[i].segments[j]:setVisible(false)
        end
    end
end

function BloodPressureWindow:resetDiastolicIndicators()
    for i = 1, 3 do
        for j = 1, 7 do
            self.instance.diastolicRow.indicators[i].segments[j]:setVisible(false)
        end
    end
end

function BloodPressureWindow:resetPulseIndicators()
    for i = 1, 3 do
        for j = 1, 7 do
            self.instance.pulseRow.indicators[i].segments[j]:setVisible(false)
        end
    end
end



Events.OnGameStart.Add(
    function()
        BloodPressureWindow:show()
    end
)
