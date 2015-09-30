module Pareto
  class NondominatedPopulation < Population

    attr_reader :comparator

    def initialize(comparator = ParetoDominanceComparator)
      @comparator = comparator
      super()
    end

    def distance(s1, s2)
      distance = s1.number_of_objectives.times.inject(0.0) do |d, i|
        d += (s1.objectives[i] - s2.objectives[i]) ** 2.0
      end
      distance ** 0.5
    end

    def add(solution)
      @data.delete_if do |s|
        flag = comparator.(solution, s)
        if flag < 0
          true
        elsif flag > 0
          return self
        elsif distance(solution, s) < Pareto::EPS
          return self
        end
      end

      super(solution)
    end

  end
end