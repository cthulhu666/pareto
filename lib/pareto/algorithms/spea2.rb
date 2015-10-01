require 'matrix'

module Pareto
  module Algorithms
    class SPEA2 < EvolutionaryAlgorithm

      class MutableDistanceMap
        attr_reader :matrix

        def initialize(raw_distance_matrix)
          @matrix = _init(raw_distance_matrix)
        end

        def _init(raw_distance_matrix)
          raw_distance_matrix = raw_distance_matrix.to_a
          m = []
          raw_distance_matrix.each_with_index do |row, i|
            distances = []
            row.each_with_index do |d, j|
              unless i == j
                distances << [j, d]
              end
            end
            distances.sort! { |a, b| a.last <=> b.last }
            m << distances
          end
          m
        end

        protected :_init

        def find_most_crowded_point
          minimum_distance = 1.0 / 0.0
          minimum_index = -1

          matrix.each_with_index do |row, i|
            point = row.first

            if point.last < minimum_distance
              minimum_distance = point.last
              minimum_index = i
            elsif point.last == minimum_distance
              row.each_with_index do |d, j|
                kdist1 = d.last
                kdist2 = matrix[minimum_index][j].last
                if kdist1 < kdist2
                  minimum_index = i
                  break
                elsif kdist2 < kdist1
                  break
                end
              end
            end
          end

          minimum_index
        end

        def remove_point(index)
          matrix.delete_at(index)
          matrix.each do |distances|
            distances.delete_if do |point|
              if point.first == index
                true
              elsif point.first > index
                point.first -= 1
              end
            end
          end
        end


      end

      class StrengthFitnessEvaluator

        def initialize(k)
          @k = k
          @comparator = Pareto::ParetoDominanceComparator
        end

        def evaluate(population)
          calculate_strength(population)
          calculate_raw_fitness(population)
          calculate_density(population, @k)
        end

        def calculate_strength(population)
          population.each { |s| s.strength = 0 }
          population.to_a.combination(2) do |s1, s2|
            comparison = @comparator.(s1, s2)
            # puts "Comparing #{s1.objectives} with #{s2.objectives}; result=#{comparison}"
            if comparison < 0
              s1.strength += 1
            elsif comparison > 0
              s2.strength += 1
            end
          end
          population
        end

        def calculate_raw_fitness(population)
          population.each { |s| s.fitness = 0 }
          population.to_a.combination(2) do |s1, s2|
            comparison = @comparator.(s1, s2)
            # remember that here lowest fitness is better!!
            if comparison < 0
              s2.fitness += s1.strength
            elsif comparison > 0
              s1.fitness += s2.strength
            end
          end
          population
        end

        def calculate_density(population, k)
          m = SPEA2.compute_distance_matrix(population)
          population.each_with_index do |s, i|
            kdist = m.row(i).sort[k]
            s.fitness += 1.0 / (kdist + 2.0)
          end
        end

      end

      attr_reader :fitness_evaluator, :number_of_offspring, :selection

      def initialize(problem:, initialization:, variation:, number_of_offspring:, k:)
        @fitness_evaluator = StrengthFitnessEvaluator.new(k)
        @number_of_offspring = number_of_offspring
        @selection = TournamentSelection.new(comparator: Pareto::FitnessComparator)
        # super
      end

      def iterate
        # mating and selection to generate offspring
        offspring = Population.new
        population_size = population.size

        while offspring.size < number_of_offspring
          parents = selection.select(variation.arity, population)
          children = variation.evolve(parents)
          offspring.add_all(children)
        end

        # evaluate the offspring
        evaluate_all(offspring)

        # evaluate the fitness of the population and offspring
        offspring.add_all(population)
        fitness_evaluator.evaluate(offspring)

        # perform environmental selection to downselect the next population
        population.clear
        population.add_all(truncate(offspring, population_size))
      end

      def initialize_algorithm
        fitness_evaluator.evaluate(population)
      end

      def truncate(offspring, size)
        survivors = Population.new

        # add all non-dominated solutions with a fitness < 1
        offspring.delete_if do |solution|
          if solution.fitness < 1.0
            survivors.add(solution)
            true
          end
        end

        if survivors.size < size
          # fill remaining spaces with dominated solutions
          offspring.sort &Pareto.FitnessComparator
          survivors.add(offspring.shift) while survivors.size < size
        elsif survivors.size > size
          # some of the survivors must be truncated
          map = MutableDistanceMap.new(SPEA2.compute_distance_matrix(survivors))
          while survivors.size > size
            index = map.find_most_crowded_point
            map.remove_point(index)
            survivors.delete_at(index)
          end
        end

        survivors
      end

      protected :truncate

      def self.compute_distance_matrix(population)
        Matrix.build(population.size, population.size) do |x, y|
          if x == y
            0
          else
            # TODO distance is symmetrical, so no need to calculate it for s1,s2 and then for s2,s1
            s1, s2 = population[x], population[y]
            distance = s1.number_of_objectives.times.inject(0.0) do |d, i|
              d += (s1.objectives[i] - s2.objectives[i]) ** 2.0
            end
            distance ** 0.5
          end
        end
      end

    end
  end
end
