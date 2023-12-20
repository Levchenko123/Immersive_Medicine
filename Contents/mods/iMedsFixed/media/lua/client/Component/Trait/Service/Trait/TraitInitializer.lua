TraitInitializer = {}

---@return TraitInitializer
function TraitInitializer:new()
    ---@class TraitInitializer
    local public = {}
    local private = {}

    ---@type Logger
    private.logger = ZCore:getContainer():get('imeds.logger.default')
    ---@type Trait[]
    private.traits = ZCore:getContainer():getByTag('imeds.trait.entity')

    function private:addXpBoost(trait, gameTrait)
        for _, perkName in ipairs(trait:getXpBoosts()) do
            local boostLevel = trait:getXpBoostValues()[perkName]
            gameTrait:addXPBoost(perkName, boostLevel)
        end
    end

    function private:addFreeRecipes(trait, gameTrait)
        for _, recipeName in ipairs(trait:getFreeRecipes()) do
            gameTrait:getFreeRecipes():add(recipeName)
        end
    end

    function private:addMutualExclusives(trait)
        for _, exclusiveTraitName in ipairs(trait:getMutualExclusives()) do
            TraitFactory.setMutualExclusive(trait:getAlias(), exclusiveTraitName)
        end
    end

    function public:addTraits()
        for _, trait in pairs(private.traits) do
            local gameTrait = TraitFactory.addTrait(
                trait:getAlias(),
                trait:getName(),
                trait:getCost(),
                trait:getDescription(),
                false
            )

            private.logger:debug(
                string.format('Trait %s added to UI', trait:getName())
            )

            if #trait:getXpBoosts() > 0 then
                private:addXpBoost(trait, gameTrait)
            end

            if #trait:getFreeRecipes() > 0 then
                private:addFreeRecipes(trait, gameTrait)
            end
        end

        for _, trait in pairs(private.traits) do
            if #trait:getMutualExclusives() > 0 then
                private:addMutualExclusives(trait)
            end
        end

        TraitFactory.sortList();
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'TraitInitializer'

    return public
end

return TraitInitializer