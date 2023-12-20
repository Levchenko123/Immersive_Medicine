BloodVolumeWindow = ISCollapsableWindow:derive("BloodVolumeWindow")

function BloodVolumeWindow:initialise()
    ISCollapsableWindow.initialise(self)
end

function BloodVolumeWindow:new(x, y, width, height)
    local public = {}
    public = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(public, self)
    self.__index = self
    public.title = ''
    public.backgroundColor = {
        r = 0,
        g = 0,
        b = 0,
        a = 0.3,
    }
    public:addToUIManager()
    public:setVisible(false)
    public:setResizable(false)
    public.pin = true

    local fontHeight = getTextManager():getFontHeight(UIFont.Small)
    local positionY = height / 2 - fontHeight

    public.titlePanel = ISRichTextPanel:new(0, positionY, 30, fontHeight)
    public.titlePanel:initialise()
    public.titlePanel:instantiate()
    public.titlePanel:noBackground()
    public.titlePanel:ignoreHeightChange()
    public.titlePanel.autosetheight = false
    public:addChild(public.titlePanel)

    return public
end

function BloodVolumeWindow:setValue(value)
    self.titlePanel.text = string.format(getText('UI_Window_BloodVolumeValue'), round(value))
    local textWidth = getTextManager():MeasureStringX(UIFont.Small, self.titlePanel.text) + 30
    self.titlePanel:setWidth(textWidth)
    self.titlePanel:setX((self:getWidth() - textWidth) / 2)
    self.titlePanel:paginate()
end

function BloodVolumeWindow:showBloodVolume(value, doctor, patient)
    self.title = patient:getDescriptor():getForename() .. ' ' .. patient:getDescriptor():getSurname()
    self:setValue(value)
end

Events.OnGameStart.Add(
    function()
        BloodVolumeWindow = BloodVolumeWindow:new(300, 250, 128, 64)
    end
)