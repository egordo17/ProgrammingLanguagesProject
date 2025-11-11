local json = require("dkjson")
local Persist = {}

function Persist.save(filename, db)
    local f = io.open(filename, "w")
    if f then
        f:write(json.encode(db, { indent = true }))
        f:close()
    end
end

function Persist.load(filename)
    local f = io.open(filename, "r")
    if f then
        local content = f:read("*a")
        f:close()
        return json.decode(content)
    end
    return nil
end

return Persist