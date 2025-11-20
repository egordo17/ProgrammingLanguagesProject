local Admin = {}

function Admin.add_assignment(course, name, points, category, due, late_penalty)
    local id = (#course.assignments > 0) and (course.assignments[#course.assignments].id + 1) or 1001
    local assignment = {
        id = id,
        name = name,
        points = points,
        category = category,
        due = due,
        late_penalty = late_penalty or 0
    }
    table.insert(course.assignments, assignment)
    return assignment  
end

-- Edit or set grade for a student
function Admin.edit_grade(student, assignment, submissions, score)
    -- Find existing submission
    local sub
    for _, s in ipairs(submissions) do
        if s.student_id == student.id and s.assignment_id == assignment.id then
            sub = s
            break
        end
    end
    if sub then
        sub.score = score
    else
        table.insert(submissions, {student_id=student.id, assignment_id=assignment.id, score=score})
    end
end

-- Change student status
function Admin.change_student_status(student, status)
    student.status = status
end

-- Remove student from course
function Admin.remove_student(course, student_id)
    for i, s in ipairs(course.students) do
        if s.id == student_id then
            table.remove(course.students, i)
            break
        end
    end
end

-- Delete assignment from course
function Admin.delete_assignment(course, assignment_id)
    for i,a in ipairs(course.assignments) do
        if a.id == assignment_id then
            table.remove(course.assignments, i)
            break
        end
    end
end

function Admin.create_and_add_student(course, db)
    print("\n--- Create New Student ---")

    io.write("Enter student name: ")
    local name = io.read()

    if name == "" then
        print("Creation cancelled.")
        return
    end

    -- Generate next ID
    local max_id = 0
    for _, s in ipairs(db.students) do
        if s.id > max_id then max_id = s.id end
    end
    local new_id = max_id + 1

    -- Create student
    local new_student = {
        id = new_id,
        name = name,
        status = "active"
    }

    -- Add to DB
    table.insert(db.students, new_student)

    -- Add to course
    table.insert(course.students, { id = new_id })

    print(string.format(
        "Created new student: %s (ID: %d) and added to course %s",
        name, new_id, course.title
    ))
end


return Admin
