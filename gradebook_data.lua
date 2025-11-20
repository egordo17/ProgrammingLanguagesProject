return {
  courses = {
    [1] = {
      title = "ITSC 4102",
      id = 1,
      assignments = {
        [1] = {
          late_penalty = 2,
          points = 100,
          category = "Exams",
          id = 101,
          name = "Midterm",
          due = "2025-11-08",
        },
        [2] = {
          late_penalty = 1,
          points = 50,
          category = "HW",
          id = 102,
          name = "Homework 1",
          due = "2025-11-05",
        },
        [3] = {
          late_penalty = 0.5,
          points = 25,
          category = "Labs",
          id = 103,
          name = "Lab 1",
          due = "2025-11-03",
        },
        [4] = {
          late_penalty = 5,
          points = 50,
          category = "HW",
          id = 104,
          name = "HW3",
          due = "2025-11-04",
        },
        [5] = {
          late_penalty = 5,
          points = 50,
          category = "hw",
          id = 106,
          name = "hw4",
          due = "2025-11-12",
        },
      },
      students = {
        [1] = {
          id = 1,
        },
        [2] = {
          id = 2,
        },
        [3] = {
          id = 9,
        },
        [4] = {
          id = 4,
        },
        [5] = {
          id = 7,
        },
        [6] = {
          id = 11,
        },
      },
    },
    [2] = {
      title = "ITSC 3155",
      id = 2,
      assignments = {
        [3] = {
          late_penalty = 2,
          points = 100,
          category = "Exams",
          id = 203,
          name = "Midterm",
          due = "2025-11-08",
        },
        [1] = {
          late_penalty = 5,
          points = 100,
          category = "Labs",
          id = 201,
          name = "Project 1",
          due = "2025-11-10",
        },
        [2] = {
          late_penalty = 1,
          points = 50,
          category = "HW",
          id = 202,
          name = "Homework 1",
          due = "2025-11-06",
        },
      },
      students = {
        [1] = {
          id = 3,
        },
        [2] = {
          id = 5,
        },
        [3] = {
          id = 6,
        },
        [4] = {
          id = 8,
        },
        [5] = {
          id = 10,
        },
      },
    },
  },
  students = {
    [1] = {
      id = 1,
      name = "Alice Johnson",
      status = "active",
    },
    [2] = {
      id = 2,
      name = "Bob Smith",
      status = "active",
    },
    [3] = {
      id = 3,
      name = "Charlie Lee",
      status = "active",
    },
    [4] = {
      id = 4,
      name = "Diana Evans",
      status = "active",
    },
    [5] = {
      id = 5,
      name = "Ethan Brown",
      status = "active",
    },
    [6] = {
      id = 6,
      name = "Fiona Clark",
      status = "active",
    },
    [7] = {
      id = 7,
      name = "George Miller",
      status = "inactive",
    },
    [8] = {
      id = 8,
      name = "Hannah Wilson",
      status = "active",
    },
    [9] = {
      id = 9,
      name = "Ian Martinez",
      status = "active",
    },
    [10] = {
      id = 10,
      name = "Julia Kim",
      status = "active",
    },
    [11] = {
      id = 11,
      name = "Toe Reh",
      status = "active",
    },
  },
  submissions = {
    [1] = {
      student_id = 1,
      score = 100,
      assignment_id = 101,
    },
    [2] = {
      student_id = 1,
      score = 45,
      assignment_id = 102,
    },
    [3] = {
      student_id = 1,
      score = 25,
      assignment_id = 103,
    },
    [4] = {
      student_id = 2,
      score = 80,
      assignment_id = 101,
    },
    [5] = {
      student_id = 2,
      score = 40,
      assignment_id = 102,
    },
    [6] = {
      student_id = 2,
      score = 20,
      assignment_id = 103,
    },
    [7] = {
      student_id = 3,
      score = 95,
      assignment_id = 201,
    },
    [8] = {
      student_id = 3,
      score = 50,
      assignment_id = 202,
    },
    [9] = {
      student_id = 3,
      score = 90,
      assignment_id = 203,
    },
    [10] = {
      student_id = 5,
      score = 92,
      assignment_id = 201,
    },
    [11] = {
      student_id = 5,
      score = 45,
      assignment_id = 202,
    },
    [12] = {
      student_id = 5,
      score = 20,
      assignment_id = 203,
    },
    [13] = {
      student_id = 6,
      score = 50,
      assignment_id = 201,
    },
    [14] = {
      student_id = 2,
      score = 50,
      assignment_id = 104,
    },
    [15] = {
      score = 100,
      student_id = 2,
      assignment_id = 105,
    },
    [16] = {
      score = 50,
      student_id = 1,
      assignment_id = 106,
    },
    [17] = {
      score = 20,
      student_id = 2,
      assignment_id = 106,
    },
    [18] = {
      score = 30,
      student_id = 9,
      assignment_id = 106,
    },
    [19] = {
      score = 40,
      student_id = 4,
      assignment_id = 106,
    },
    [20] = {
      score = 50,
      student_id = 7,
      assignment_id = 106,
    },
  },
  weights = {
    Exams = 0.5,
    HW = 0.3,
    Labs = 0.2,
  },
}
