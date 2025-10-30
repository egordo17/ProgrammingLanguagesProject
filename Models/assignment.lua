local Assignment = {}
Assignment.__index = Assignment

local function parse_date(datestr)
    local y, m, d, H, M = datestr:match("(%d+)%-(%d+)%-(%d+) (%d+):(%d+)")
    return os.time({year=y, month=m, day=d, hour=H, min=M})
end

function Assignment:new(id, course_id, category, points, due, drop, late_penalty)
    local self = setmetatable({}, Assignment)
    self.id = id
    self.course_id = course_id
    self.category = category
    self.points = points
    self.due = parse_date(due)
    self.drop = drop or false
    self.late_penalty = late_penalty or 0
    return self
end

