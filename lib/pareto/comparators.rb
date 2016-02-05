module Pareto
  module Comparators
    RankComparator = -> (s1, s2) { s1.rank <=> s2.rank }

    CrowdingComparator = -> (s1, s2) { s2.crowding_distance <=> s1.crowding_distance }

    FitnessComparator = -> (s1, s2) { s1.fitness <=> s2.fitness }

    NondominatedSortingComparator = -> (s1, s2) { [s1.rank, s2.crowding_distance] <=> [s2.rank, s1.crowding_distance] }

    AggregateConstraintComparator = proc do |s1, s2|
      constraints1 = Pareto.get_constraints(s1)
      constraints2 = Pareto.get_constraints(s2)

      if (constraints1 != 0.0) || (constraints2 != 0.0)
        if constraints1 == 0.0
          -1
        elsif constraints2 == 0.0
          1
        else
          constraints1 <=> constraints2
        end
      else
        0
      end
    end

    ParetoObjectiveComparator = proc do |s1, s2|
      dominate1 = false
      dominate2 = false

      s1.number_of_objectives.times do |i|
        if s1.objectives[i] < s2.objectives[i]
          dominate1 = true
          next 0 if dominate2
        elsif s1.objectives[i] > s2.objectives[i]
          dominate2 = true
          next 0 if dominate1
        end
      end

      next 0 if dominate1 == dominate2
      next -1 if dominate1
      next 1
    end

    ParetoDominanceComparator = proc do |s1, s2|
      a = AggregateConstraintComparator.call(s1, s2)
      a == 0 ? ParetoObjectiveComparator.call(s1, s2) : a
    end
  end
end
