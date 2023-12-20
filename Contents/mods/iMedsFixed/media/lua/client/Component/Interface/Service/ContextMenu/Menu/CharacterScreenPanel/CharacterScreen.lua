CharacterScreen = {}
CharacterScreen.render = ISCharacterScreen.render

function ISCharacterScreen:render()
    CharacterScreen.render(self)

    if Survivor:isKnowOwnBloodGroup() then
        self:drawText(Survivor:getBlood():getGroup():getName(), self.avatarX + self.avatarWidth + 25, 45, 1, 1, 1, 1, UIFont.Small);
    end
end