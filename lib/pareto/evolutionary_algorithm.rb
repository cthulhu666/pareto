module Pareto
  class EvolutionaryAlgorithm < Algorithm

    attr_reader :population, :initialization

    def initialize(problem:, population:, archive: nil, initialization:)
      @population = population
      @initialization = initialization
      super(problem)
    end

    def initialize_algorithm
      initial_solutions = initialization.setup

      evaluate_all(initial_solutions)
      population.add_all(initial_solutions)
    end

    def result
      rs = NondominatedPopulation.new
      rs.add_all(population)
      # TODO rs.add_all(archive) if archive
      rs
    end

  end
end
