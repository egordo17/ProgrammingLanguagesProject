local Persist = {}

local function serialize(tbl, indent)
    indent = indent or 0
    local spacing = string.rep("  ", indent)
    local parts = {"{\n"}
    for k, v in pairs(tbl) do
        local key
        if type(k) == "string" and k:match("^%a[%w_]*$") then
            key = k
        else
            key = "[" .. tostring(k) .. "]"
        end

        local value
        if type(v) == "table" then
            value = serialize(v, indent + 1)
        elseif type(v) == "string" then
            value = string.format("%q", v)
        else
            value = tostring(v)
        end

        table.insert(parts, string.format("%s  %s = %s,\n", spacing, key, value))
    end
    table.insert(parts, spacing .. "}")
    return table.concat(parts)
end

function Persist.save(filename, tbl)
    local f = io.open(filename, "w")
    if f then
        f:write("return " .. serialize(tbl) .. "\n")
        f:close()
    else
        error("Cannot open file: " .. filename)
    end
end

function Persist.load(filename)
    local ok, tbl = pcall(dofile, filename)
    if ok then return tbl end
    return nil
end

return Persist
