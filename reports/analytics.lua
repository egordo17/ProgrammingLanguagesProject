local Analytics = {}

local function mean(tbl)
    local sum = 0
    for _, v in ipairs(tbl) do sum = sum + v end
    return #tbl > 0 and sum / #tbl or 0
end

local function median(tbl)
    table.sort(tbl)
    local n = #tbl
    if n == 0 then return 0 end
    if n % 2 == 1 then return tbl[math.ceil(n / 2)] end
    return (tbl[n / 2] + tbl[n / 2 + 1]) / 2
end

-- Compute assignment stats only for active students
function Analytics.assignment_stats(assignment, submissions, students)
    local scores = {}
    for _, sub in ipairs(submissions) do
        local student
        for _, s in ipairs(students) do
            if s.id == sub.student_id then student = s break end
        end
        if student and student.status == "active" and sub.assignment_id == assignment.id then
            table.insert(scores, sub.score)
        end
    end

    local avg = mean(scores)
    local med = median(scores)
    table.sort(scores)
    local top1, bottom1 = {}, {}
    for i = 1, math.min(1, #scores) do
        table.insert(bottom1, scores[i])
        table.insert(top1, scores[#scores - i + 1])
    end

    return {average = avg, median = med, top1 = top1, bottom1 = bottom1}
end

return Analytics
