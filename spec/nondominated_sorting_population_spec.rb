require 'spec_helper'

module Pareto
  describe NondominatedSortingPopulation do
    let(:pop) { NondominatedSortingPopulation.new }

    describe '#truncate' do
      context 'with solutions of differing ranks' do
        let(:s1) { Solution.new objectives: [0.5, 0.5] }
        let(:s2) { Solution.new objectives: [0.0, 0.0] }
        let(:s3) { Solution.new objectives: [1.0, 1.0] }

        before do
          pop.add(s1)
          pop.add(s2)
          pop.add(s3)
          pop.truncate(1)
        end

        it { expect(pop.size).to eq 1 }
        it { expect(pop).to_not include(s1) }
        it { expect(pop).to include(s2) }
        it { expect(pop).to_not include(s3) }
      end

      context 'with equally-ranked solutions' do
        let(:s1) { Solution.new objectives: [0.0, 1.0] }
        let(:s2) { Solution.new objectives: [0.5, 0.5] }
        let(:s3) { Solution.new objectives: [1.0, 0.0] }

        before do
          pop.add(s1)
          pop.add(s2)
          pop.add(s3)
          pop.truncate(2)
        end

        it { expect(pop.size).to eq 2 }
        it { expect(pop).to include(s1) }
        it { expect(pop).to_not include(s2) }
        it { expect(pop).to include(s3) }
      end

      context 'with mixed solutions' do
        let :solutions do
          [[0.0, 0.0], [0.0, 1.0], [0.45, 0.55], [0.5, 0.5], [0.73, 0.27], [0.74, 0.26], [0.75, 0.25], [1.0, 0.0]]
            .map { |o| Solution.new(objectives: o) }
        end

        before do
          pop.add_all solutions
          pop.truncate(5)
        end

        it { expect(pop.size).to eq 5 }
        [0, 1, 2, 3, 7].each do |i|
          it { expect(pop).to include solutions[i] }
        end
        [4, 5, 6].each do |i|
          it { expect(pop).to_not include solutions[i] }
        end
      end
    end
  end
end
