local Submission = {}
Submission.__index = Submission

function Submission.new(tbl)
    return setmetatable(tbl, Submission)
end

return Submission
