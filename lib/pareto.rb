require 'pareto/version'
require 'pareto/solution'
require 'pareto/population'
require 'pareto/fast_nondominated_sorting'
require 'pareto/nondominated_population'
require 'pareto/nondominated_sorting_population'
require 'pareto/tournament_selection'
require 'pareto/real_variable'

require 'pareto/algorithm'
require 'pareto/evolutionary_algorithm'
require 'pareto/algorithms/nsgaii'
require 'pareto/algorithms/spea2'

require 'pareto/problems/viennet'

require 'pareto/operators/one_point_crossover'
require 'pareto/operators/simulated_binary_crossover'
require 'pareto/operators/compound_variation'

require 'pareto/comparators'

module Pareto
  EPS = 1e-10 # TODO: check this thingy

  # TODO: move to Solution class?
  def self.get_constraints(solution)
    solution.constraints.inject(0.0) do |s, c|
      s + c.abs
    end
  end
end
