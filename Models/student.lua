local Student = {}
Student.__index = Student

function Student.new(tbl)
    tbl.status = tbl.status or "active"
    return setmetatable(tbl, Student)
end

return Student
