module Pareto
  class Solution

    attr_accessor :objectives, :constraints, :rank, :crowding_distance, :variables

    def initialize(objectives: [], constraints: [], variables: [])
      @objectives = objectives
      @constraints = constraints
      @variables = variables
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
