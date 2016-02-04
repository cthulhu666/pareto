module Pareto
  class Solution
    attr_accessor :objectives, :constraints, :rank, :crowding_distance, :variables, :fitness, :strength

    def initialize(objectives: [], constraints: [], variables: [], fitness: nil, rank: nil, crowding_distance: nil)
      @objectives = objectives
      @constraints = constraints
      @variables = variables
      @fitness = fitness
      @rank = rank
      @crowding_distance = crowding_distance
    end

    def number_of_objectives
      objectives.size
    end

    def number_of_variables
      variables.size
    end

    def initialize_copy(source)
      super
      @objectives = @objectives.dup
      @constraints = @constraints.dup
      @variables = @variables.dup
    end
  end
end
