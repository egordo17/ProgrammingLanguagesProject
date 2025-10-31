-- reports/course.lua
-- Beta version: shows a simple course summary using mock data
-- This file works on its own without depending on student.lua or analytics.lua.

local M = {}

-- helper to make a histogram
local function histogram(values)
  local bins = {
    {lo=0, hi=60, label="0-60"},
    {lo=60, hi=70, label="60-70"},
    {lo=70, hi=80, label="70-80"},
    {lo=80, hi=90, label="80-90"},
    {lo=90, hi=100, label="90-100"},
  }
  local counts = {}
  for i=1,#bins do counts[i]=0 end
  for _,v in ipairs(values) do
    for i,b in ipairs(bins) do
      if v >= b.lo and v < b.hi then counts[i]=counts[i]+1; break end
      if i==#bins and v==b.hi then counts[i]=counts[i]+1 end
    end
  end
  for i,b in ipairs(bins) do
    print(string.format("%-9s | %s (%d)", b.label, string.rep("█", counts[i]), counts[i]))
  end
end

-- Main report function
function M.print_course_summary()
  -- Mock data (replace later with real db + Gradebook)
  local course = { id="ITSC4102", title="Intro to Software Engineering" }
  local roster = { active=22, inactive=3 }
  local weights = { Exams=0.5, Homework=0.3, Labs=0.2 }
  local finalPercents = {95, 88, 72, 65, 54, 81, 90, 77, 69, 100, 83, 60, 85}

  -- Print course summary
  print("# Course Summary")
  print(string.format("Course: %s (%s)", course.title, course.id))
  print(string.format("Roster: %d active, %d inactive", roster.active, roster.inactive))
  print("\nCategory Weights:")
  for cat, w in pairs(weights) do
    print(string.format("  - %-10s %.1f%%", cat, w*100))
  end

  print("\nGrade Distribution:")
  histogram(finalPercents)
end

return M
