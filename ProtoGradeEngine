local Gradebook = {}

-- Compute weighted final grade for a student (only active students count)
-- weights = {Exams=0.5, Homework=0.3, Labs=0.2}
function Gradebook.compute_student_final(student_id, course, submissions, weights, students)
    local student
    for _, s in ipairs(students) do
        if s.id == student_id then student = s break end
    end
    if not student or student.status ~= "active" then
        return 0 
    end

    local category_totals, category_scores = {}, {}

    for _, a in ipairs(course.assignments) do
        local cat = a.category
        category_totals[cat] = (category_totals[cat] or 0) + a.points

        local sub_score = 0
        for _, s in ipairs(submissions) do
            if s.student_id == student_id and s.assignment_id == a.id then
                sub_score = s.score
                break
            end
        end

        category_scores[cat] = (category_scores[cat] or 0) + sub_score
    end

    local final = 0
    for cat, weight in pairs(weights) do
        local percent = 0
        if category_totals[cat] and category_totals[cat] > 0 then
            percent = category_scores[cat]/category_totals[cat]
        end
        final = final + percent * weight
    end

    return final * 100
end

return Gradebook
