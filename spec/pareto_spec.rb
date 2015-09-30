require 'spec_helper'

describe Pareto do

  describe Pareto::AggregateConstraintComparator do

    describe 'dominance' do
      let(:s1) { Pareto::Solution.new([], constraints: [0.0]) }
      let(:s2) { Pareto::Solution.new([], constraints: [1.0]) }
      let(:s3) { Pareto::Solution.new([], constraints: [-1.0]) }

      it { expect(Pareto::AggregateConstraintComparator.(s1, s2)).to be < 0 }
      it { expect(Pareto::AggregateConstraintComparator.(s1, s3)).to be < 0 }
      it { expect(Pareto::AggregateConstraintComparator.(s2, s1)).to be > 0 }
      it { expect(Pareto::AggregateConstraintComparator.(s3, s1)).to be > 0 }
    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new([], constraints: [0.0]) }
      let(:s2) { Pareto::Solution.new([], constraints: [0.0]) }
      let(:s3) { Pareto::Solution.new([], constraints: [1.0]) }
      let(:s4) { Pareto::Solution.new([], constraints: [-1.0]) }

      it { expect(Pareto::AggregateConstraintComparator.(s1, s2)).to eq 0 }
      it { expect(Pareto::AggregateConstraintComparator.(s2, s1)).to eq 0 }
      it { expect(Pareto::AggregateConstraintComparator.(s3, s4)).to eq 0 }
      it { expect(Pareto::AggregateConstraintComparator.(s4, s3)).to eq 0 }
    end

  end

  describe Pareto::ParetoObjectiveComparator do
    describe 'dominance' do
      let(:s1) { Pareto::Solution.new([0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new([0.0, 0.0, 0.0]) }
      let(:s3) { Pareto::Solution.new([0.5, 0.0, 0.5]) }

      it { expect(Pareto::ParetoObjectiveComparator.(s1, s2)).to be > 0 }
      it { expect(Pareto::ParetoObjectiveComparator.(s1, s3)).to be > 0 }
      it { expect(Pareto::ParetoObjectiveComparator.(s2, s1)).to be < 0 }
      it { expect(Pareto::ParetoObjectiveComparator.(s3, s1)).to be < 0 }
    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new([0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new([0.5, 0.0, 1.0]) }

      it { expect(Pareto::ParetoObjectiveComparator.(s1, s2)).to eq 0 }
      it { expect(Pareto::ParetoObjectiveComparator.(s2, s1)).to eq 0 }
    end

    describe 'equals' do
      let(:s1) { Pareto::Solution.new([0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new([0.5, 0.5, 0.5]) }

      it { expect(Pareto::ParetoObjectiveComparator.(s1, s2)).to eq 0 }
      it { expect(Pareto::ParetoObjectiveComparator.(s2, s1)).to eq 0 }
    end

  end

  describe Pareto::PARETO_DOMINANCE_COMPARATOR do

    describe 'dominance' do

      let(:s1) { Pareto::Solution.new([0.0, 0.0], constraints: [1.0]) }
      let(:s2) { Pareto::Solution.new([1.0, 1.0], constraints: [0.0]) }
      let(:s3) { Pareto::Solution.new([1.0, 0.0], constraints: [0.0]) }

      it { expect(Pareto::PARETO_DOMINANCE_COMPARATOR.(s1, s2)).to be > 0 }
      it { expect(Pareto::PARETO_DOMINANCE_COMPARATOR.(s2, s1)).to be < 0 }
      it { expect(Pareto::PARETO_DOMINANCE_COMPARATOR.(s1, s3)).to be > 0 }
      it { expect(Pareto::PARETO_DOMINANCE_COMPARATOR.(s3, s1)).to be < 0 }
      it { expect(Pareto::PARETO_DOMINANCE_COMPARATOR.(s2, s3)).to be > 0 }
      it { expect(Pareto::PARETO_DOMINANCE_COMPARATOR.(s3, s2)).to be < 0 }

    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new([0.75, 0.25], constraints: [1.0]) }
      let(:s2) { Pareto::Solution.new([0.25, 0.75], constraints: [1.0]) }

      it { expect(Pareto::PARETO_DOMINANCE_COMPARATOR.(s1, s2)).to eq 0 }
      it { expect(Pareto::PARETO_DOMINANCE_COMPARATOR.(s2, s1)).to eq 0 }
    end

  end

  describe Pareto::CROWDING_COMPARATOR do

    context 'dominance' do
      let(:s1) { s = Pareto::Solution.new([]); s.crowding_distance = 1.0 / 0.0; s }
      let(:s2) { s = Pareto::Solution.new([]); s.crowding_distance = 0.0; s }
      let(:s3) { s = Pareto::Solution.new([]); s.crowding_distance = 1.0; s }

      it { expect(Pareto::CROWDING_COMPARATOR.(s1, s2)).to be < 0 }
      it { expect(Pareto::CROWDING_COMPARATOR.(s2, s1)).to be > 0 }
      it { expect(Pareto::CROWDING_COMPARATOR.(s3, s2)).to be < 0 }
      it { expect(Pareto::CROWDING_COMPARATOR.(s2, s3)).to be > 0 }
    end

    context 'nondominance' do
      let(:s1) { s = Pareto::Solution.new([]); s.crowding_distance = 1.0 / 0.0; s }
      let(:s2) { s = Pareto::Solution.new([]); s.crowding_distance = 1.0 / 0.0; s }
      let(:s3) { s = Pareto::Solution.new([]); s.crowding_distance = 1.0; s }
      let(:s4) { s = Pareto::Solution.new([]); s.crowding_distance = 1.0; s }

      it { expect(Pareto::CROWDING_COMPARATOR.(s1, s2)).to eq 0 }
      it { expect(Pareto::CROWDING_COMPARATOR.(s2, s1)).to eq 0 }

      it { expect(Pareto::CROWDING_COMPARATOR.(s3, s4)).to eq 0 }
      it { expect(Pareto::CROWDING_COMPARATOR.(s4, s3)).to eq 0 }
    end

  end

  describe Pareto::RANK_COMPARATOR do

    context 'dominance' do
      let(:s1) { s = Pareto::Solution.new([]); s.rank = 0; s }
      let(:s2) { s = Pareto::Solution.new([]); s.rank = 1; s }

      it { expect(Pareto::RANK_COMPARATOR.(s1, s2)).to be < 0 }
      it { expect(Pareto::RANK_COMPARATOR.(s2, s1)).to be > 0 }
    end

    context 'nondominance' do
      let(:s1) { s = Pareto::Solution.new([]); s.rank = 0; s }
      let(:s2) { s = Pareto::Solution.new([]); s.rank = 0; s }

      it { expect(Pareto::RANK_COMPARATOR.(s1, s2)).to eq 0 }
      it { expect(Pareto::RANK_COMPARATOR.(s2, s1)).to eq 0 }
    end

  end

end

