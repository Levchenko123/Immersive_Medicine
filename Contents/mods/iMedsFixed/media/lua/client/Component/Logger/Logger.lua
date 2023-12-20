Logger = {
    DEBUG = 100,
    INFO = 200,
    NOTICE = 250,
    WARNING = 300,
    ERROR = 400,
    CRITICAL = 500,
    ALERT = 550,
    EMERGENCY = 600,
}

---@return Logger
function Logger:new()
    ---@class Logger
    local public = {}
    local private = {}

    private.levels = {
        { value = Logger.DEBUG, alias = 'DEBUG' },
        { value = Logger.INFO, alias = 'INFO' },
        { value = Logger.NOTICE, alias = 'NOTICE' },
        { value = Logger.WARNING, alias = 'WARNING' },
        { value = Logger.ERROR, alias = 'ERROR' },
        { value = Logger.CRITICAL, alias = 'CRITICAL' },
        { value = Logger.ALERT, alias = 'ALERT' },
        { value = Logger.EMERGENCY, alias = 'EMERGENCY' },
    }

    ---@param message string
    ---@param context table|nil
    function public:debug(message, context)
        return private:log(Logger.DEBUG, message, context)
    end

    ---@param message string
    ---@param context table|nil
    function public:info(message, context)
        return private:log(Logger.INFO, message, context)
    end

    ---@param message string
    ---@param context table|nil
    function public:notice(message, context)
        return private:log(Logger.NOTICE, message, context)
    end

    ---@param message string
    ---@param context table|nil
    function public:warning(message, context)
        return private:log(Logger.WARNING, message, context)
    end

    ---@param message string
    ---@param context table|nil
    function public:error(message, context)
        return private:log(Logger.ERROR, message, context)
    end

    ---@param message string
    ---@param context table|nil
    function public:critical(message, context)
        return private:log(Logger.CRITICAL, message, context)
    end

    ---@param message string
    ---@param context table|nil
    function public:alert(message, context)
        return private:log(Logger.ALERT, message, context)
    end

    ---@param message string
    ---@param context table|nil
    function public:emergency(message, context)
        return private:log(Logger.EMERGENCY, message, context)
    end

    ---@param level string
    ---@param message string
    ---@param context table|nil
    function private:log(level, message, context)
        local loggerLevel = private:toLoggerLevel(level)
        print(
            string.format(
                '[%s] %s: (iMeds) %s',
                os.date('%H:%M:%S'),
                loggerLevel,
                message
            )
        )

        if context ~= nil then
            var_dump(context)
        end
    end

    ---@param level number
    ---@return string
    function private:toLoggerLevel(level)
        for _, v in pairs(private.levels) do
            if v.value == level then
                return v.alias
            end
        end
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Logger'

    return public
end

return Logger