require 'spec_helper'

module Pareto
  describe FastNondominatedSorting do
    let(:pop) { Population.new }

    let(:sorting) { FastNondominatedSorting.new }

    before do
      pop.add s1
      pop.add s2
      pop.add s3
      sorting.evaluate(pop)
    end

    describe 'rank assignment' do
      let(:s1) { Solution.new objectives: [0.0, 0.0] }
      let(:s2) { Solution.new objectives: [0.5, 0.5] }
      let(:s3) { Solution.new objectives: [1.0, 1.0] }

      it { expect(s1.rank).to eq 0 }
      it { expect(s2.rank).to eq 1 }
      it { expect(s3.rank).to eq 2 }
    end

    describe 'crowding assignment' do
      let(:s1) { Solution.new objectives: [0.0, 1.0] }
      let(:s2) { Solution.new objectives: [0.5, 0.5] }
      let(:s3) { Solution.new objectives: [1.0, 0.0] }

      it { expect(s1.rank).to eq 0 }
      it { expect(s2.rank).to eq 0 }
      it { expect(s3.rank).to eq 0 }

      it { expect(s1.crowding_distance).to eq 1.0 / 0.0 }
    end
  end
end
