local Assignment = {}
Assignment.__index = Assignment

function Assignment.new(tbl)
    tbl.category = tbl.category or "Uncategorized"
    tbl.due = tbl.due or "1970-01-01"
    tbl.late_penalty = tbl.late_penalty or 0
    return setmetatable(tbl, Assignment)
end

function Assignment:get_average(submissions)
    local total, count = 0,0
    for _, sub in ipairs(submissions) do
        if sub.assignment_id == self.id then
            total = total + sub.score
            count = count + 1
        end
    end
    if count==0 then return 0 end
    return total/count
end

return Assignment
