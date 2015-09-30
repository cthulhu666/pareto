module Pareto
  class TournamentSelection

    attr_reader :size, :comparator

    def initialize(size: 2, comparator: ParetoDominanceComparator)
      @size = size
      @comparator = comparator
    end

    def select(population)
      winner = population.sample
      (1...size).each do
        candidate = population.sample
        if comparator.(winner, candidate) > 0
          winner = candidate
        end
      end

      winner
    end


  end
end
