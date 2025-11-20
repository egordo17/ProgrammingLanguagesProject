-- cli/commands.lua
-- Declarative registry of supported commands.
-- min_args/max_args: nil means "no limit".
local COMMANDS = {
  help = {
    summary = "Show help for all commands or one command.",
    usage   = "help [command]",
    min_args = 0, max_args = 1
  },
  version = {
    summary = "Show CLI version.",
    usage   = "version"
  },
  exit = {
    summary = "Exit the shell.",
    usage   = "exit"
  },
  quit = {
    summary = "Alias for exit.",
    usage   = "quit"
  },

  -- Example “reports” wiring (adjust to your APIs as they solidify):
  ["report:course"] = {
    summary = "Generate/print the course report.",
    usage   = "report:course <course_id>",
    min_args = 1, max_args = 1
  },
  ["report:audit"] = {
    summary = "Run Admin Audit report.",
    usage   = "report:audit"
  },
  ["report:profbook"] = {
    summary = "Generate Professor Grade Book report.",
    usage   = "report:profbook <course_id>",
    min_args = 1, max_args = 1
  },

  -- Example “models” wiring (tailor to your module APIs):
  ["model:new-course"] = {
    summary = "Create/seed a course from a file (JSON/Lua).",
    usage   = "model:new-course <path>",
    min_args = 1, max_args = 1
  }
}

return {
  COMMANDS = COMMANDS
}
