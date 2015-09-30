module Pareto
  class Solution

    attr_accessor :objectives, :constraints, :rank, :crowding_distance

    def initialize(objectives, constraints: [])
      @objectives = objectives
      @constraints = constraints
    end

    def number_of_objectives
      objectives.size
    end

  end
end
