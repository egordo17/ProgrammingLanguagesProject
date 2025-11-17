local Query = {}

function Query.find_student_by_id(course, sid)
    for _, s in ipairs(course.students) do
        if s.id == sid then return s end
    end
    return nil
end

return Query
