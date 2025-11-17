local CourseReport = {}
local Analytics = require("reports.analytics")

function CourseReport.show(course, submissions, students)
    print("\n--- Course: " .. course.title .. " ---")
    print("Assignments Overview (active students only):")
    for _, a in ipairs(course.assignments) do
        local stats = Analytics.assignment_stats(a, submissions, students)
        print(string.format("%s | Avg: %.2f | Median: %.2f | Top1: %s | Bottom1: %s",
            a.name,
            stats.average,
            stats.median,
            table.concat(stats.top1, ", "),
            table.concat(stats.bottom1, ", ")
        ))
    end
end

return CourseReport
