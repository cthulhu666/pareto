module Pareto
  class TournamentSelection
    attr_reader :size, :comparator

    # TODO: change comparator
    # TournamentSelection selection = new TournamentSelection(2,
    #                                                        new ChainedComparator(
    #                                                                new ParetoDominanceComparator(),
    #                                                                    new CrowdingComparator()));

    def initialize(size: 2, comparator: ParetoDominanceComparator)
      @size = size
      @comparator = comparator
    end

    # TODO: arity as named param with default 2
    def select(arity, population)
      arity.times.map { select_one(population) }
    end

    def select_one(population)
      winner = population.sample
      (1...size).each do
        candidate = population.sample
        winner = candidate if comparator.call(winner, candidate) > 0
      end

      winner
    end
    protected :select_one
  end
end
