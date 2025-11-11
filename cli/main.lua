-- cli/main.lua
-- Entry point REPL for the ProgrammingLanguagesProject (Lua).

local Router = require("cli.router")

local function banner()
  print("Welcome to PLP CLI. Type 'help' for commands, 'exit' to quit.")
end

local function repl()
  local router = Router:new()
  banner()
  while true do
    io.write("plp> ")
    local line = io.read("*l")
    if not line then io.write("\n"); break end -- EOF
    local ok, err = pcall(function() router:route(line) end)
    if not ok then
      io.write("[fatal] " .. tostring(err) .. "\n")
    end
  end
end

-- allow: lua cli/main.lua
repl()
