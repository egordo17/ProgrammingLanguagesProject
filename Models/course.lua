local Course = {}
Course.__index = Course

function Course:new(id, title, sections)
    local self = setmetatable({}, Course)
    self.id = id
    self.title = title
    self.sections = sections or {}
    return self
end

return Course
