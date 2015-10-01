module Pareto
  class EvolutionaryAlgorithm < Algorithm

    attr_reader :population

    def initialize(problem:, population:, archive: nil, initialization: nil)
      @population = population
      super(problem)
    end

  end
end
