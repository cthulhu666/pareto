module Pareto
  class Algorithm

    attr_reader :number_of_evaluations, :problem

    def initialize(problem)
      @number_of_evaluations = 0
      @problem = problem
      @initialized = false
    end

    def evaluate_all(solutions)
      solutions.each { |s| evaluate(s) }
    end

    def evaluate(solution)
      problem.evaluate(solution)
      @number_of_evaluations += 1
    end

    def step
      unless initialized?
        initialize_algorithm
        @initialized = true
      else
        iterate
      end
    end

    def initialized?
      @initialized
    end

    def initialize_algorithm
      raise NotImplementedError
    end
    protected :initialize_algorithm

    def iterate
      raise NotImplementedError
    end
    protected :iterate


  end
end
