require 'Component/Trait/Entity/Pharmacist'

ExamineDrugWindow = ISCollapsableWindow:derive("ExamineDrugWindow")

function ExamineDrugWindow:initialise()
    ISCollapsableWindow.initialise(self)
end

function ExamineDrugWindow:new(x, y, width, height)
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
    public.resizable = false
    public.pin = true

    local panelWidth = width - 20
    local positionX = 10

    public.titlePanel = ISRichTextPanel:new(positionX, 35, panelWidth, 0)
    public.titlePanel:initialise()
    public.titlePanel:instantiate()
    public.titlePanel:noBackground()
    public.titlePanel:ignoreHeightChange()
    public.titlePanel.autosetheight = true
    public:addChild(public.titlePanel)

    public.descriptionPanel = ISRichTextPanel:new(positionX, 70, panelWidth, 100)
    public.descriptionPanel:initialise()
    public.descriptionPanel:instantiate()
    public.descriptionPanel:noBackground()
    public.descriptionPanel:ignoreHeightChange()
    public.descriptionPanel.autosetheight = false
    public:addChild(public.descriptionPanel)

    public.sideEffectPanel = ISRichTextPanel:new(positionX, 170, panelWidth, 100)
    public.sideEffectPanel:initialise()
    public.sideEffectPanel:instantiate()
    public.sideEffectPanel:noBackground()
    public.sideEffectPanel:ignoreHeightChange()
    public.sideEffectPanel.autosetheight = false
    public:addChild(public.sideEffectPanel)

    public.dosagePanel = ISRichTextPanel:new(positionX, 270, panelWidth, 40)
    public.dosagePanel:initialise()
    public.dosagePanel:instantiate()
    public.dosagePanel:noBackground()
    public.dosagePanel:ignoreHeightChange()
    public.dosagePanel.autosetheight = false
    public:addChild(public.dosagePanel)

    return public
end

function ExamineDrugWindow:setTitle(title)
    self.titlePanel.text = string.format(getText('UI_Window_DrugTitle'), title)
    self.titlePanel:paginate()
end

function ExamineDrugWindow:setDescription(description)
    self.descriptionPanel.text = string.format(getText('UI_Window_DrugDescription'), description)
    self.descriptionPanel:paginate()
end

function ExamineDrugWindow:setSideEffectDescription(description)
    self.sideEffectPanel.text = string.format(getText('UI_Window_SideEffectDescription'), description)
    self.sideEffectPanel:paginate()
end

function ExamineDrugWindow:setDosageDescription(description)
    self.dosagePanel.text = string.format(getText('UI_Window_DosageDescription'), description)
    self.dosagePanel:paginate()
end

---@param drug Drug
function ExamineDrugWindow:showDrugInfo(drug, doctor)
    self.doctor = doctor
    self.drug = drug
    self.title = drug:getName()

    self:setTitle(drug:getName())
    self:setDescription(drug:getDescription())

    self:setSideEffectDescription('?')
    self:setDosageDescription('?')
    if doctor:getPerkLevel(Perks.Doctor) >= 3 or doctor:HasTrait(Pharmacist.alias) then
        self:setSideEffectDescription(drug:getSideEffects())
        self:setDosageDescription(drug:getMaxDose())
    end
end

Events.OnGameStart.Add(
    function()
        ExamineDrugWindow = ExamineDrugWindow:new(300, 250, 375, 455)
    end
)