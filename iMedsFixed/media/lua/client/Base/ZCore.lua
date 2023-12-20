ZCore = {}

---@return ZCore
function ZCore:new()
    ---@class ZCore
    local public = {}
    local private = {}

    private.container = require('Component/DependencyInjection/Container'):new()

    ---Get Container instance
    ---@see Container
    function public:getContainer()
        return private.container
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'ZCore'

    return public
end

ZCore = ZCore:new()

Events.OnGameBoot.Add(
    function()
        local container = ZCore:getContainer()

        container:register(require 'Component/Logger/Logger', 'imeds.logger.default', {})

        local logger = container:get('imeds.logger.default')
        logger:info('Immercive Medicine core successfully loaded!')
    end
)


