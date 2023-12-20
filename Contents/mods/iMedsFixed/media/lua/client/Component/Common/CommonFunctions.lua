---@param T table
---@return number
function tableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

---@return boolean
---@param e any
---@param t table
function in_table (e, t)
    for _, v in pairs(t) do
        if (v == e) then
            return true
        end
    end

    return false
end

---@param child table
---@param parent table
---@return void
function extend (child, parent)
    for k, v in pairs(parent) do
        child[k] = v
    end
end

function unpack (t, i)
    i = i or 1
    if t[i] ~= nil then
        return t[i], unpack(t, i + 1)
    end
end

---@return string
function uniqid()
    local timestamp = os.time();
    local random = ZombRand(10000000);
    local random2 = ZombRand(10000000, 99999999);
    local microtime = timestamp + random;
    local md5 = string.format("%8x%06x", math.floor(microtime), (microtime - math.floor(microtime)) * 1000000);
    md5 = md5 .. "." .. random2;
    return md5;
end

local function string(o)
    return '"' .. tostring(o) .. '"'
end

local function recurse(o, indent)
    if indent == nil then
        indent = ''
    end
    local indent2 = indent .. '  '
    if type(o) == 'table' then
        local s = indent .. '{' .. '\n'
        local first = true
        for k, v in pairs(o) do
            if first == false then
                s = s .. ', \n'
            end
            if type(k) ~= 'number' then
                k = string(k)
            end
            s = s .. indent2 .. '[' .. k .. '] = ' .. recurse(v, indent2)
            first = false
        end
        return s .. '\n' .. indent .. '}'
    else
        return string(o)
    end
end

function var_dump(...)
    local args = { ... }
    if #args > 1 then
        var_dump(args)
    else
        print(recurse(args[1]))
    end
end

function round10(number)
    return math.floor(number / 10 + 0.5) * 10
end
