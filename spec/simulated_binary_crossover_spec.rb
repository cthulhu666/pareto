require 'spec_helper'

module Pareto
  module Operators
    describe SimulatedBinaryCrossover do

      R = (-1.0/0.0)..(1.0/0.0)

      def var(v, bounds = -10.0..10.0)
        RealVariable.new(value: v, bounds: bounds)
      end

      describe '#evolve' do

        # Tests if the offspring form clusters distributed around each parent.

        let(:operator) { SimulatedBinaryCrossover.new }

        let(:s1) { Solution.new(variables: [var(2.0), var(2.0)]) }
        let(:s2) { Solution.new(variables: [var(-2.0), var(-2.0)]) }

        let(:centroids) { [s1, s2, c1, c2]}
        let(:c1) { Solution.new(variables:[var(2.0, R), var(-2.0, R)]) }
        let(:c2) { Solution.new(variables:[var(-2.0, R), var(2.0, R)]) }

        let :offspring do
          1000.times.inject([]) do |arr, _i|
            arr + operator.evolve([s1, s2])
          end
        end

        it 'offspring form clusters distributed around each parent' do
          expect(offspring.size).to eq 2000
          # TODO
        end

      end

    end
  end
end
