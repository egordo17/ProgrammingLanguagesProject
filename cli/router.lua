-- cli/router.lua
-- Command parsing + dispatch to project modules with friendly fallbacks.

local commands = require("cli.commands").COMMANDS

local Router = {}
Router.__index = Router

local CLI_VERSION = "0.1.0"

local function split_words(s)
  local out = {}
  for w in string.gmatch(s, "%S+") do table.insert(out, w) end
  return out
end

local function safe_require(modname)
  local ok, mod = pcall(require, modname)
  if ok then return mod, nil end
  return nil, mod -- 'mod' holds the error message
end

function Router:new()
  return setmetatable({}, self)
end

function Router:route(line)
  local parts = split_words(line or "")
  if #parts == 0 then return end

  local cmd = parts[1]
  table.remove(parts, 1) -- args

  local spec = commands[cmd]
  if not spec then
    -- allow short aliases like: report course 123 -> report:course 123
    if cmd == "report" and parts[1] then
      local sub = parts[1]; table.remove(parts, 1)
      cmd = "report:" .. sub
      spec = commands[cmd]
    end
  end

  if not spec then
    io.write(string.format("Unknown command: %s. Type 'help' for commands.\n", cmd))
    return
  end

  if spec.min_args and #parts < spec.min_args then
    io.write("Usage: " .. spec.usage .. "\n")
    return
  end
  if spec.max_args and #parts > spec.max_args then
    io.write("Usage: " .. spec.usage .. "\n")
    return
  end

  local handler = self["handle__" .. cmd:gsub(":", "__")]
  if not handler then
    io.write(string.format("Command '%s' not implemented yet.\n", cmd))
    return
  end

  local ok, err = pcall(handler, self, parts)
  if not ok then
    io.write("[error] " .. tostring(err) .. "\n")
  end
end

-- ---------- Handlers ----------

function Router:handle__help(args)
  if #args == 1 then
    local name = args[1]
    local spec = commands[name]
    if not spec then
      io.write(string.format("No such command '%s'.\n", name))
      return
    end
    io.write(string.format("%s\nUsage: %s\n", spec.summary, spec.usage))
    return
  end

  io.write("Available commands:\n")
  -- pretty width
  local width = 0
  for k,_ in pairs(commands) do width = math.max(width, #k) end
  local list = {}
  for k,v in pairs(commands) do table.insert(list, {k,v}) end
  table.sort(list, function(a,b) return a[1] < b[1] end)
  for _,kv in ipairs(list) do
    local k, v = kv[1], kv[2]
    io.write(string.format("  %-" .. width .. "s  %s\n", k, v.summary))
  end
end

function Router:handle__version(_)
  io.write("PLP CLI version " .. CLI_VERSION .. "\n")
end

function Router:handle__exit(_)
  os.exit(0)
end

function Router:handle__quit(args)  -- alias
  self:handle__exit(args)
end

-- Reports

function Router:handle__report__course(args)
  local course_id = args[1]
  local report, err = safe_require("reports.course")
  if not report then
    io.write("reports.course not available: " .. tostring(err) .. "\n")
    return
  end
  -- Adjust to your real API:
  -- Expecting: report.generate(course_id)
  if type(report.generate) ~= "function" then
    io.write("Expected function reports.course.generate(course_id)\n")
    return
  end
  local ok, rerr = pcall(report.generate, course_id)
  if not ok then io.write("[report error] " .. tostring(rerr) .. "\n") end
end

function Router:handle__report__audit(_)
  local audit, err = safe_require("reports.AdminAudit")
  if not audit then
    io.write("reports.AdminAudit not available: " .. tostring(err) .. "\n")
    return
  end
  -- Expecting: audit.run()
  if type(audit.run) ~= "function" then
    io.write("Expected function reports.AdminAudit.run()\n")
    return
  end
  local ok, rerr = pcall(audit.run)
  if not ok then io.write("[report error] " .. tostring(rerr) .. "\n") end
end

function Router:handle__report__profbook(args)
  local course_id = args[1]
  local prof, err = safe_require("reports.professorGradeBook")
  if not prof then
    io.write("reports.professorGradeBook not available: " .. tostring(err) .. "\n")
    return
  end
  -- Expecting: prof.generate(course_id)
  if type(prof.generate) ~= "function" then
    io.write("Expected function reports.professorGradeBook.generate(course_id)\n")
    return
  end
  local ok, rerr = pcall(prof.generate, course_id)
  if not ok then io.write("[report error] " .. tostring(rerr) .. "\n") end
end

-- Models

function Router:handle__model__new_course(args)
  local path = args[1]
  local course, err = safe_require("Models.course")
  if not course then
    io.write("Models.course not available: " .. tostring(err) .. "\n")
    return
  end
  -- Example expected API: course.create_from_file(path)
  if type(course.create_from_file) ~= "function" then
    io.write("Expected function Models.course.create_from_file(path)\n")
    return
  end
  local ok, rerr = pcall(course.create_from_file, path)
  if not ok then io.write("[model error] " .. tostring(rerr) .. "\n") end
end

return Router
