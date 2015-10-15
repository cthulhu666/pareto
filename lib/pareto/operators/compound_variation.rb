module Pareto
  module Operators
    class CompoundVariation

      def initialize(*operators)
        @operators = [operators].flatten
      end

      def evolve(parents)
        result = parents.dup
        @operators.each do |op|
          if op.arity == result.size
            result = operator.eveolve(result)
          elsif op.arity == 1
            result.size.times { |i| result[i] = op.evolve([result[i]]).first }
          else
            raise "Invalid number of parents"
          end
        end
        result
      end

    end
  end
end
