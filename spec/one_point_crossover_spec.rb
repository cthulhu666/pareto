require 'spec_helper'

module Pareto
  module Operators
    describe OnePointCrossover do

      describe '#evolve' do

        let :parents do
          2.times.map { Solution.new(variables:[rand, rand]) }
        end

        let(:variation) { OnePointCrossover.new }

        let(:offspring) { variation.evolve(parents) }

        it { expect(offspring.size).to eq 2 }
        it { expect(offspring.first.variables.size).to eq 2 }
        it { expect(offspring.last.variables.size).to eq 2 }

      end

    end
  end
end
