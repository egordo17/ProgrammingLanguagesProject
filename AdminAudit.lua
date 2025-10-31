-- admin_audit_undo_min.lua
local M = {}
M.__index = M

local function clone_rec(rec)
  if not rec then return nil end
  local t = {}
  for k,v in pairs(rec) do t[k]=v end
  return t
end

local function now() return os.time() end

function M.new(opts)
  opts = opts or {}
  return setmetatable({
    actor = opts.actor or "system",
    max_history = opts.max_history or 50,
    students = {},          -- id -> {id,name,enrolled,active}
    audit = {},             -- append-only events
    undo_stack = {},        -- stack of {label, apply, revert, details}
    redo_stack = {}
  }, M)
end

-- ============== Audit helpers ==============
function M:log(action, details)
  table.insert(self.audit, {
    id = #self.audit + 1,
    who = self.actor,
    when = now(),
    action = action,
    details = details or {}
  })
end

function M:audit_tail(n)
  local n = n or 10
  local out = {}
  local start = math.max(1, #self.audit - n + 1)
  for i=start, #self.audit do out[#out+1] = self.audit[i] end
  return out
end

-- ============== Core command runner ==============
function M:_exec(label, apply, revert, details)
  apply()
  self:log(label, details)
  self.redo_stack = {}
  local cmd = { label=label, apply=apply, revert=revert, details=details }
  table.insert(self.undo_stack, cmd)
  if #self.undo_stack > self.max_history then
    table.remove(self.undo_stack, 1)
  end
  return true
end

function M:undo()
  local cmd = self.undo_stack[#self.undo_stack]
  if not cmd then return false, "nothing to undo" end
  table.remove(self.undo_stack)
  cmd.revert()
  self:log("undo:"..cmd.label, cmd.details)
  table.insert(self.redo_stack, cmd)
  return true
end

function M:redo()
  local cmd = self.redo_stack[#self.redo_stack]
  if not cmd then return false, "nothing to redo" end
  table.remove(self.redo_stack)
  cmd.apply()
  self:log("redo:"..cmd.label, cmd.details)
  table.insert(self.undo_stack, cmd)
  return true
end

-- ============== Student ops ==============
function M:get_student(id) return self.students[id] end

function M:list_students()
  local out = {}
  for _, s in pairs(self.students) do out[#out+1] = clone_rec(s) end
  table.sort(out, function(a,b) return a.id < b.id end)
  return out
end

function M:enroll_student(id, name)
  local before = clone_rec(self.students[id]) -- could be nil
  local label = ("enroll:%s"):format(id)
  local function apply()
    local s = self.students[id]
    if not s then
      self.students[id] = { id=id, name=name or id, enrolled=true, active=true }
    else
      s.enrolled, s.active = true, true
      if name then s.name = name end
    end
  end
  local function revert()
    if before == nil then self.students[id] = nil
    else self.students[id] = clone_rec(before) end
  end
  return self:_exec(label, apply, revert, {id=id, name=name})
end

function M:unenroll_student(id)
  assert(self.students[id], ("student %s not found"):format(id))
  local before = clone_rec(self.students[id])
  local label = ("unenroll:%s"):format(id)
  local function apply()
    local s = self.students[id]
    s.enrolled, s.active = false, false
  end
  local function revert() self.students[id] = clone_rec(before) end
  return self:_exec(label, apply, revert, {id=id})
end

function M:deactivate_student(id)
  assert(self.students[id], ("student %s not found"):format(id))
  local before = clone_rec(self.students[id])
  local label = ("deactivate:%s"):format(id)
  local function apply() self.students[id].active = false end
  local function revert() self.students[id] = clone_rec(before) end
  return self:_exec(label, apply, revert, {id=id})
end

function M:reactivate_student(id)
  assert(self.students[id], ("student %s not found"):format(id))
  local before = clone_rec(self.students[id])
  local label = ("reactivate:%s"):format(id)
  local function apply() self.students[id].active = true end
  local function revert() self.students[id] = clone_rec(before) end
  return self:_exec(label, apply, revert, {id=id})
end

-- ============== Bulk ops ==============
-- rows: { {id=..., name=?, active=?, enrolled=?}, ... }
function M:batch_import(rows)
  assert(type(rows) == "table", "rows must be a table")
  local befores = {}
  for _, r in ipairs(rows) do befores[r.id] = clone_rec(self.students[r.id]) end
  local label = "batch_import"
  local function apply()
    for _, r in ipairs(rows) do
      local s = self.students[r.id]
      if not s then
        self.students[r.id] = {
          id=r.id, name=r.name or r.id,
          enrolled = (r.enrolled ~= false),
          active   = (r.active   ~= false),
        }
      else
        if r.name then s.name = r.name end
        if r.enrolled ~= nil then s.enrolled = r.enrolled end
        if r.active   ~= nil then s.active   = r.active   end
      end
    end
  end
  local function revert()
    for _, r in ipairs(rows) do
      local prev = befores[r.id]
      if prev == nil then self.students[r.id] = nil
      else self.students[r.id] = clone_rec(prev) end
    end
  end
  return self:_exec(label, apply, revert, {count=#rows})
end

-- changes: { {id=..., active=?, enrolled=?}, ... }
function M:batch_status_change(changes)
  assert(type(changes) == "table", "changes must be a table")
  for _, ch in ipairs(changes) do
    assert(self.students[ch.id], ("student %s not found"):format(ch.id))
  end
  local befores = {}
  for _, ch in ipairs(changes) do befores[ch.id] = clone_rec(self.students[ch.id]) end
  local label = "batch_status_change"
  local function apply()
    for _, ch in ipairs(changes) do
      local s = self.students[ch.id]
      if ch.active   ~= nil then s.active   = ch.active   end
      if ch.enrolled ~= nil then s.enrolled = ch.enrolled end
    end
  end
  local function revert()
    for _, ch in ipairs(changes) do
      self.students[ch.id] = clone_rec(befores[ch.id])
    end
  end
  return self:_exec(label, apply, revert, {count=#changes})
end

-- ============== quick demo (optional) ==============
if ... == nil then
  local admin = M.new{ actor = "owner@school.edu", max_history = 20 }
  admin:batch_import({
    {id="u1", name="Ava"},
    {id="u2", name="Ben"},
    {id="u3", name="Chloe", active=false, enrolled=false},
  })
  admin:enroll_student("u3")
  admin:deactivate_student("u2")
  admin:reactivate_student("u2")
  admin:batch_status_change({ {id="u1", active=false}, {id="u2", enrolled=false} })

  print("Students:")
  for _, s in ipairs(admin:list_students()) do
    print(s.id, s.name, s.enrolled, s.active)
  end

  print("\nUndo last:")
  admin:undo()

  print("\nAudit tail:")
  for _, e in ipairs(admin:audit_tail(10)) do
    print(("[%d] %s %s"):format(e.id, e.action, e.who))
  end
end

return M
