module Pareto
  module Algorithms
    class NSGAII < EvolutionaryAlgorithm

      attr_reader :selection, :variation

      def initialize(problem: , population:, archive: nil, initialization: nil, variation:, selection: TournamentSelection.new)
        fail ArgumentError, population.class unless population.is_a?(NondominatedSortingPopulation)
        @variation = variation
        @selection = selection
        super(problem: problem, population: population)
      end


      def iterate
        offspring = Population.new
        population_size = population.size

        while offspring.size < population_size
          parents = selection.select(2, population)
          children = variation.evolve(parents)
          offspring.add_all(children)
        end

        evaluate_all(offspring)

        #if (archive != null) {
        #    archive.addAll(offspring);
        #}

        population.add_all(offspring)
        population.truncate(population_size)
      end


    end
  end
end