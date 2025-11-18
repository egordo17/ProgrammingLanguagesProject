local Course = {}
Course.__index = Course

function Course.new(tbl)
    tbl.assignments = tbl.assignments or {}
    tbl.students = tbl.students or {}
    return setmetatable(tbl, Course)
end

return Course
