require 'pareto/nondominated_population'

module Pareto
  class FastNondominatedSorting

    def initialize(comparator = ParetoDominanceComparator)
      @comparator = comparator
    end

    def evaluate(population)
      remaining = population.to_a

      rank = 0

      loop do
        front = NondominatedPopulation.new
        front.add_all remaining
        front.each { |s| s.rank = rank }
        remaining -= front.to_a

        update_crowding_distance(front)

        return if remaining.empty?

        rank += 1
      end

    end

    def update_crowding_distance(front)
      n = front.size
      if n < 3
        front.each { |s| s.crowding_distance = 1.0/0.0 }
      else
        front.each { |s| s.crowding_distance = 0.0 }

        front.first.number_of_objectives.times do |i|
          front.sort! { |a, b| a.objectives[i] <=> b.objectives[i] }

          min_objective = front[0].objectives[i]
          max_objective = front[n-1].objectives[i]

          front[0].crowding_distance = 1.0 / 0.0
				  front[n-1].crowding_distance = 1.0 / 0.0

          (1...n-1).each do |j|
            distance = front[j].crowding_distance
            distance += (front[j + 1].objectives[i] - front[j - 1].objectives[i])	/ (max_objective - min_objective)
            front[j].crowding_distance = distance
          end

        end
      end
    end

  end
end