local Persist = require("store.persist")
local Student = require("models.student")
local Course = require("models.course")
local Assignment = require("models.assignment")
local Submission = require("models.submission")
local Admin = require("services.admin")
local CourseReport = require("reports.course")
local StudentReport = require("reports.student")

-- Load DB
local db_path = "spec/test_data.json"
local db = Persist.load(db_path)
if not db then
    print("Failed to load database at " .. db_path)
    os.exit(1)
end

------------------------------------------------------------
-- Utility Functions
------------------------------------------------------------

-- Find student by ID
local function find_student(id)
    for _, s in ipairs(db.students) do
        if s.id == id then return s end
    end
end

-- Check if student is already in course
local function is_student_in_course(course, id)
    for _, s in ipairs(course.students) do
        if s.id == id then
            return true
        end
    end
    return false
end

-- Add student to course
local function add_student_to_course(course)
    print("\nAvailable students to add:")

    local has_available = false
    for _, s in ipairs(db.students) do
        if not is_student_in_course(course, s.id) then
            has_available = true
            print(string.format("ID: %d  Name: %s", s.id, s.name))
        end
    end

    if not has_available then
        print("All students are already in this course.")
        return
    end

    io.write("Enter Student ID to add (or press Enter to cancel): ")
    local input = io.read()
    if input == "" then
        print("Add student cancelled.")
        return
    end

    local sid = tonumber(input)
    if not sid then
        print("Invalid ID. Must be a number.")
        return
    end

    local student_obj = find_student(sid)
    if not student_obj then
        print("No student found with that ID.")
        return
    end

    if is_student_in_course(course, sid) then
        print("That student is already enrolled in this course.")
        return
    end

    table.insert(course.students, { id = sid })
    print("Student " .. student_obj.name .. " added to course " .. course.title .. ".")
end

-- Show student report
local function show_student(student, course)
    StudentReport.show(student, course, db.submissions)
end

------------------------------------------------------------
-- Course Menu
------------------------------------------------------------

local function course_menu(course)
    while true do
        print("\n--- "..course.title.." Menu ---")
        print("1. Show Students")
        print("2. Search Student by Name")
        print("3. Show Assignments")
        print("4. Edit Grade")
        print("5. Add Assignment")
        print("6. Delete Assignment")
        print("7. Add Student to Course")
        print("8. Remove Student from Course")
        print("9. Change Student Status")
        print("10. Save DB")
        print("0. Back to Courses")
        io.write("Choose option: ")
        local opt = io.read()

        -- Show all students
        if opt == "1" then
            for _, s in ipairs(course.students) do
                local student_obj = find_student(s.id)
                StudentReport.show(student_obj, course, db.submissions, db.weights, db.students)
            end

        -- Search student by name
        elseif opt == "2" then
            io.write("Enter student name: ")
            local name = io.read()
            for _, s in ipairs(course.students) do
                local student_obj = find_student(s.id)
                if student_obj.name:lower():find(name:lower()) then
                    StudentReport.show(student_obj, course, db.submissions, db.weights, db.students)
                end
            end

        -- Show assignments
        elseif opt == "3" then
            CourseReport.show(course, db.submissions, db.students)

        -- Edit grade
        elseif opt == "4" then
            io.write("Enter Assignment ID to edit: ")
            local aid = tonumber(io.read())
            io.write("Enter Student ID: ")
            local sid = tonumber(io.read())
            io.write("Enter new score (in points): ")
            local score = tonumber(io.read())
            
            local student_obj = find_student(sid)
            local assignment_obj
            for _, a in ipairs(course.assignments) do 
                if a.id == aid then assignment_obj = a end 
            end
            
            if student_obj and assignment_obj then
                Admin.edit_grade(student_obj, assignment_obj, db.submissions, score)
                print("Grade updated.")
            else
                print("Invalid student or assignment ID.")
            end

        -- Add assignment
        elseif opt == "5" then
            io.write("Assignment name: ")
            local name = io.read()
            io.write("Points (100/50/25): ")
            local points = tonumber(io.read())
            io.write("Category (Exams/HW/Labs): ")
            local cat = io.read()
            io.write("Due date (YYYY-MM-DD): ")
            local due = io.read()
            io.write("Late penalty: ")
            local lp = tonumber(io.read())

            local assignment_obj = Admin.add_assignment(course, name, points, cat, due, lp)

            print("Enter initial grades for students (leave empty to skip):")
            for _, s in ipairs(course.students) do
                io.write("Student " .. s.id .. " (" .. find_student(s.id).name .. ") score: ")
                local val = io.read()
                if val ~= "" then
                    Admin.edit_grade(find_student(s.id), assignment_obj, db.submissions, tonumber(val))
                end
            end
            print("Assignment added.")

        -- Delete assignment
        elseif opt == "6" then
            io.write("Enter Assignment ID to delete: ")
            local aid = tonumber(io.read())
            Admin.delete_assignment(course, aid)
            print("Assignment deleted.")

        -- Add student to course
        elseif opt == "7" then
            add_student_to_course(course)

        -- Remove student from course
        elseif opt == "8" then
            io.write("Enter Student ID to remove: ")
            local sid = tonumber(io.read())
            Admin.remove_student(course, sid)
            print("Student removed from course.")

        -- Change student status
        elseif opt == "9" then
            io.write("Enter Student ID: ")
            local sid = tonumber(io.read())
            io.write("Enter status (active/inactive): ")
            local status = io.read()
            local student_obj = find_student(sid)
            if student_obj then
                Admin.change_student_status(student_obj, status)
                print("Status updated.")
            else
                print("Invalid Student ID.")
            end

        -- Save DB
        elseif opt == "10" then
            Persist.save(db_path, db)
            print("Database saved.")

        -- Back to courses
        elseif opt == "0" then
            break
        else
            print("Invalid option.")
        end
    end
end

-- Main Menu

while true do
    print("\n--- Courses ---")

    for i, c in ipairs(db.courses) do
        print(string.format("%d. %s (ID: %d)", i, c.title, c.id))
    end
    print("0. Exit\n")

    io.write("Select an option: ")
    local input = io.read()
    local sel = tonumber(input)

    if not sel then
        print("Invalid input. Please enter a number.")
    elseif sel == 0 then
        print("Exiting program. Goodbye!")
        break
    elseif db.courses[sel] then
        local course = db.courses[sel]
        course_menu(course)
    else
        print("Invalid selection. Please choose a valid course number.")
    end
end