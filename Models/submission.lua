local Submission = {}
Submission.__index = Submission

function Submission:new(student_id, assignment_id, score, timestamp)
    local self = setmetatable({}, Submission)
    self.student_id = student_id
    self.assignment_id = assignment_id
    self.score = score
    self.timestamp = timestamp or os.date("%Y-%m-%d %H:%M:%S")
    return self
end

return Submission
