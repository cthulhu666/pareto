module Pareto
  module Problems
    class Viennet
      def evaluate(solution)
        x, y = *solution.variables.map(&:value)

        f1 = x**2 + (y - 1.0)**2
        f2 = x**2 + (y + 1.0)**2 + 1.0
        f3 = (x - 1.0)**2 + y**2 + 2.0

        solution.objectives = [f1, f2, f3]
      end

      def new_solution
        bounds = -2.0..2.0
        Solution.new(variables: [
                       RealVariable.new(value: rand(bounds), bounds: bounds),
                       RealVariable.new(value: rand(bounds), bounds: bounds)
                     ])
      end
    end
  end
end
