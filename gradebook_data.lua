return {
  submissions = {
    [13] = {
      student_id = 6,
      score = 50,
      assignment_id = 201,
    },
    [7] = {
      student_id = 3,
      score = 95,
      assignment_id = 201,
    },
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
    [4] = {
      student_id = 2,
      score = 80,
      assignment_id = 101,
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
    [5] = {
      student_id = 2,
      score = 40,
      assignment_id = 102,
    },
    [10] = {
      student_id = 5,
      score = 92,
      assignment_id = 201,
    },
    [14] = {
      student_id = 2,
      score = 50,
      assignment_id = 104,
    },
    [3] = {
      student_id = 1,
      score = 25,
      assignment_id = 103,
    },
    [6] = {
      student_id = 2,
      score = 20,
      assignment_id = 103,
    },
    [12] = {
      student_id = 5,
      score = 20,
      assignment_id = 203,
    },
    [11] = {
      student_id = 5,
      score = 45,
      assignment_id = 202,
    },
  },
  weights = {
    HW = 0.3,
    Exams = 0.5,
    Labs = 0.2,
  },
  students = {
    [7] = {
      id = 7,
      name = "George Miller",
      status = "active",
    },
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
    [4] = {
      id = 4,
      name = "Diana Evans",
      status = "active",
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
    [5] = {
      id = 5,
      name = "Ethan Brown",
      status = "active",
    },
    [10] = {
      id = 10,
      name = "Julia Kim",
      status = "active",
    },
    [3] = {
      id = 3,
      name = "Charlie Lee",
      status = "active",
    },
    [6] = {
      id = 6,
      name = "Fiona Clark",
      status = "active",
    },
  },
  courses = {
    [1] = {
      id = 1,      title = "ITSC 4102",
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
      },
      assignments = {
        [1] = {
          late_penalty = 2,
          name = "Midterm",
          category = "Exams",
          id = 101,
          points = 100,
          due = "2025-11-08",
        },
        [2] = {
          late_penalty = 1,
          name = "Homework 1",
          category = "HW",
          id = 102,
          points = 50,
          due = "2025-11-05",
        },
        [3] = {
          late_penalty = 0.5,
          name = "Lab 1",
          category = "Labs",
          id = 103,
          points = 25,
          due = "2025-11-03",
        },
        [4] = {
          late_penalty = 5,
          name = "HW3",
          category = "HW",
          id = 104,
          points = 50,
          due = "2025-11-04",
        },
        [5] = {
          late_penalty = 0,
          name = "JOhn",
          category = "Exams",
          id = 105,
          points = 100,
          due = "2025-02-19",
        },
      },
    },
    [2] = {
      id = 2,      title = "ITSC 3155",
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
      assignments = {
        [1] = {
          late_penalty = 5,
          name = "Project 1",
          category = "Labs",
          id = 201,
          points = 100,
          due = "2025-11-10",
        },
        [2] = {
          late_penalty = 1,
          name = "Homework 1",
          category = "HW",
          id = 202,
          points = 50,
          due = "2025-11-06",
        },
        [3] = {
          late_penalty = 2,
          name = "Midterm",
          category = "Exams",
          id = 203,
          points = 100,
          due = "2025-11-08",
        },
      },
    },
  },
}
