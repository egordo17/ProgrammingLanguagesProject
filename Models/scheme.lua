local Scheme = {}
Scheme.__index = Scheme

function Scheme:new(weights, cutoffs)
    local self = setmetatable({}, Scheme)
    self.weights = weights or { Homework = 0.4, Quizzes = 0.2, Exams = 0.4 }
    self.cutoffs = cutoffs or { A = 90, B = 80, C = 70, D = 60 }
    return self
end

return Scheme
