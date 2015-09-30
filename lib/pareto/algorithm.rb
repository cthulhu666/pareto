module Pareto
  class Algorithm

    attr_reader :number_of_evaluations, :problem

    def initialize(problem)
      @number_of_evaluations = 0
      @problem = problem
    end

    def evaluate_all(solutions)
      solutions.each { |s| evaluate(s) }
    end

    def evaluate(solution)
      problem.evaluate(solution)
      @number_of_evaluations += 1
    end

    def step
      # TODO state machine?
      iterate
    end

    def iterate
      raise NotImplementedError
    end
    protected :iterate


  end
end
