local Student = {}
Student.__index = Student

Student.Status = {
    ACTIVE = "active",
    INACTIVE = "inactive"
}

function Student:new(id, name, status)
    local self = setmetatable({}, Student)
    self.id = id
    self.name = name
    self.status = status or Student.Status.ACTIVE
    return self
end

return Student
