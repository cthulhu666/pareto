require "pareto/version"
require "pareto/solution"
require "pareto/population"
require "pareto/fast_nondominated_sorting"
require "pareto/nondominated_population"
require "pareto/nondominated_sorting_population"

require "pareto/algorithms/nsgaii"

module Pareto

  EPS = 1e-10 # TODO check this thingy

  RANK_COMPARATOR = -> (s1, s2) { s1.rank <=> s2.rank }

  CROWDING_COMPARATOR = -> (s1, s2) { s2.crowding_distance <=> s1.crowding_distance }

  NONDOMINATED_SORTING_COMPARATOR = Proc.new do |s1, s2|
    a = RANK_COMPARATOR.(s1, s2)
    unless a == 0
      a
    else
      CROWDING_COMPARATOR.(s1, s2)
    end
  end

  AggregateConstraintComparator = Proc.new do |s1, s2|
    constraints1 = get_constraints(s1)
    constraints2 = get_constraints(s2)

    if ((constraints1 != 0.0) || (constraints2 != 0.0))
      if (constraints1 == 0.0)
        -1
      elsif (constraints2 == 0.0)
        1
      else
        constraints1 <=> constraints2
      end
    else
      0
    end
  end

  ParetoObjectiveComparator = Proc.new do |s1, s2|
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

  PARETO_DOMINANCE_COMPARATOR = Proc.new do |s1, s2|
    a = AggregateConstraintComparator.(s1, s2)
    unless a == 0
      a
    else
      ParetoObjectiveComparator.(s1, s2)
    end
  end

  # TODO move to Solution class?
  def self.get_constraints(solution)
    solution.constraints.inject(0.0) do |s, c|
      s += c.abs
    end
  end

end
