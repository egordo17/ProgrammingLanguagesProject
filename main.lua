local Persist = require("store.persist")
local Student = require("models.student")
local Course = require("models.course")
local Assignment = require("models.assignment")
local Submission = require("models.submission")
local Admin = require("services.admin")
local CourseReport = require("reports.course")
local StudentReport = require("reports.student")

-- Load DB from Lua table
local db_path = "gradebook_data.lua"
local db = Persist.load(db_path)
if not db then
    print("Failed to load database at " .. db_path)
    os.exit(1)
end

-- Tracks whether changes have been made since last save
local db_dirty = false

------------------------------------------------------------
-- Generic helpers for safe IO and calls
------------------------------------------------------------

local function read_number(prompt)
    while true do
        io.write(prompt)
        local input = io.read()
        local n = tonumber(input)
        if n then
            return n
        end
        print("Please enter a valid number.")
    end
end

local function read_nonempty_string(prompt)
    while true do
        io.write(prompt)
        local input = io.read()
        if input ~= "" then
            return input
        end
        print("Input cannot be empty.")
    end
end

local function read_optional_number(prompt)
    while true do
        io.write(prompt)
        local input = io.read()
        if input == "" then
            return nil
        end
        local n = tonumber(input)
        if n then
            return n
        end
        print("Please enter a valid number or leave blank to skip.")
    end
end

local function safe_call(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        print("[error in " .. label .. "]: " .. tostring(err))
    end
end

local function confirm(prompt)
    while true do
        io.write(prompt .. " (y/n): ")
        local input = io.read()
        if not input then
            return false
        end
        input = input:lower()
        if input == "y" or input == "yes" then
            return true
        elseif input == "n" or input == "no" or input == "" then
            return false
        else
            print("Please answer y or n.")
        end
    end
end

------------------------------------------------------------
-- Utility Functions
------------------------------------------------------------

local function find_student(id)
    for _, s in ipairs(db.students) do
        if s.id == id then return s end
    end
end

local function is_student_in_course(course, id)
    for _, s in ipairs(course.students) do
        if s.id == id then
            return true
        end
    end
    return false
end

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
local function show_student(student, course)
    if not student then
        print("[warning] Tried to show report for missing student.")
        return
    end
    safe_call("StudentReport.show", StudentReport.show, student, course, db.submissions, db.weights, db.students)
end

------------------------------------------------------------
-- Course Menu
------------------------------------------------------------

local function course_menu(course)
    while true do
        print("\n--- " .. course.title .. " Menu ---")
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

        if opt == "1" then
            for _, s in ipairs(course.students) do
                local student_obj = find_student(s.id)
                if student_obj then
                    show_student(student_obj, course)
                else
                    print("[warning] Course references missing student ID " .. tostring(s.id))
                end
            end

        elseif opt == "2" then
            local name = read_nonempty_string("Enter student name: ")
            local found_any = false
            for _, s in ipairs(course.students) do
                local student_obj = find_student(s.id)
                if student_obj and student_obj.name:lower():find(name:lower()) then
                    show_student(student_obj, course)
                    found_any = true
                end
            end
            if not found_any then
                print("No students found matching that name.")
            end

        elseif opt == "3" then
            safe_call("CourseReport.show", CourseReport.show, course, db.submissions, db.students)

        elseif opt == "4" then
            local aid = read_number("Enter Assignment ID to edit: ")
            local sid = read_number("Enter Student ID: ")
            local score = read_number("Enter new score (in points): ")

            local student_obj = find_student(sid)
            local assignment_obj
            for _, a in ipairs(course.assignments) do
                if a.id == aid then assignment_obj = a end
            end

            if not student_obj then
                print("No student found with ID " .. sid)
            elseif not assignment_obj then
                print("No assignment found with ID " .. aid)
            else
                safe_call("Admin.edit_grade", Admin.edit_grade, student_obj, assignment_obj, db.submissions, score)
                db_dirty = true
                print("Grade updated.")
            end

        elseif opt == "5" then
            local name = read_nonempty_string("Assignment name: ")
            local points = read_number("Points (100/50/25): ")
            local cat = read_nonempty_string("Category (Exams/HW/Labs): ")
            local due = read_nonempty_string("Due date (YYYY-MM-DD): ")
            local lp = read_number("Late penalty: ")

            local assignment_obj
            safe_call("Admin.add_assignment", function()
                assignment_obj = Admin.add_assignment(course, name, points, cat, due, lp)
            end)

            if not assignment_obj then
                print("Failed to add assignment (see error above).")
            else
                db_dirty = true
                print("Enter initial grades for students (leave empty to skip):")
                for _, s in ipairs(course.students) do
                    local student_obj = find_student(s.id)
                    if student_obj then
                        local prompt = "Student " .. s.id .. " (" .. student_obj.name .. ") score: "
                        local score = read_optional_number(prompt)
                        if score ~= nil then
                            safe_call("Admin.edit_grade", Admin.edit_grade, student_obj, assignment_obj, db.submissions, score)
                            db_dirty = true
                        end
                    else
                        print("[warning] Course references missing student ID " .. tostring(s.id))
                    end
                end
                print("Assignment added.")
            end

        elseif opt == "6" then
            local aid = read_number("Enter Assignment ID to delete: ")
            safe_call("Admin.delete_assignment", Admin.delete_assignment, course, aid)
            db_dirty = true
            print("Assignment deleted.")

        elseif opt == "7" then
            Admin.create_and_add_student(course, db)    

        elseif opt == "8" then
            local sid = read_number("Enter Student ID to remove: ")
            local student_obj = find_student(sid)
            if not student_obj then
                print("No student found with ID " .. sid)
            else
                safe_call("Admin.remove_student", Admin.remove_student, course, sid)
                db_dirty = true
                print("Student removed from course.")
            end

        elseif opt == "9" then
            local sid = read_number("Enter Student ID: ")
            local status = read_nonempty_string("Enter status (active/inactive): ")
            local student_obj = find_student(sid)
            if student_obj then
                safe_call("Admin.change_student_status", Admin.change_student_status, student_obj, status)
                db_dirty = true
                print("Status updated.")
            else
                print("Invalid Student ID.")
            end

        elseif opt == "10" then
            safe_call("Persist.save", Persist.save, db_path, db)
            db_dirty = false
            print("Database saved.")

        elseif opt == "0" then
            print("Returning to course list.")
            break

        else
            print("Invalid option.")
        end
    end
end

------------------------------------------------------------
-- Main Menu
------------------------------------------------------------

while true do
    print("\n--- Courses ---")
    for i, c in ipairs(db.courses) do
        print(string.format("%d. %s (ID: %d)", i, c.title, c.id))
    end
    print("0. Exit\n")

    local sel = read_number("Select an option: ")

    if sel == 0 then
        if db_dirty then
            print("\n⚠ You have unsaved changes!")
            if confirm("Exit without saving?") then
                print("Exiting program without saving changes. Goodbye!")
                break
            else
                print("Exit cancelled. Please save your changes.")
            end
        else
            print("Exiting program. Goodbye!")
            break
        end
    elseif db.courses[sel] then
        local course = db.courses[sel]
        course_menu(course)
    else
        print("Invalid selection. Please choose a valid course number.")
    end
end
