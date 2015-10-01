module Pareto
  module Operators
    class OnePointCrossover

      attr_reader :probability

      def initialize(probability: 0.90)
        @probability = probability
      end

      def evolve(parents)
        # TODO not really one point, fix it
        n = parents.first.number_of_variables
        children = parents.map &:dup
        if rand <= probability
          sum = children.map(&:variables).flatten.shuffle!
          children[0].variables = sum[0...n]
          children[1].variables = sum[n..-1]
        end
        children
      end

    end
  end
end
