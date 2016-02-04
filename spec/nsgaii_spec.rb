require 'spec_helper'

module Pareto
  module Algorithms
    class TestProblem
      def evaluate(solution)
        x = solution.variables.first.value
        solution.objectives = [
          (x**2.0 - x * 5.0), (x * 2.0 - x * 3.0)
        ]
      end

      def new_solution
        Solution.new(variables: [RealVariable.new(bounds: -10.0..10.0, value: rand(-10.0..10.0))])
      end
    end

    describe NSGAII do
      let(:problem) { TestProblem.new }

      let :population do
        pop = NondominatedSortingPopulation.new
        pop.add_all(10.times.map { problem.new_solution })
        pop
      end

      let :algorithm do
        NSGAII.new(
          problem: problem,
          variation: Pareto::Operators::SimulatedBinaryCrossover.new,
          population: population
        )
      end

      pending
    end
  end
end
