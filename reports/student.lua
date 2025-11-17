local StudentReport = {}
local Gradebook = require("services.gradebook")

function StudentReport.show(student, course, submissions, weights, students)
    print(string.format("\n--- Student Report: %s (ID: %d) ---", student.name, student.id))
    print("Status: " .. student.status)
    print(string.format("%-5s %-20s %-6s %-6s %-7s", "ID", "Assignment", "Score", "Points", "Percent"))

    local total_score, total_points = 0, 0
    for _, a in ipairs(course.assignments) do
        local sub_score = 0
        for _, s in ipairs(submissions) do
            if s.student_id == student.id and s.assignment_id == a.id then
                sub_score = s.score
                break
            end
        end
        total_score = total_score + sub_score
        total_points = total_points + a.points
        print(string.format("%-5s %-20s %-6.1f %-6d %-7.1f", a.id, a.name, sub_score, a.points, (sub_score / a.points * 100)))
    end
    local overall = total_points > 0 and (total_score / total_points * 100) or 0
    print(string.format("Total Score: %d/%d | Overall: %.2f%%", total_score, total_points, overall))
end

return StudentReport
