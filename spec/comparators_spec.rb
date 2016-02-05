require 'spec_helper'

include Pareto::Comparators

describe Pareto::Comparators do
  describe AggregateConstraintComparator do
    describe 'dominance' do
      let(:s1) { Pareto::Solution.new(objectives: [], constraints: [0.0]) }
      let(:s2) { Pareto::Solution.new(objectives: [], constraints: [1.0]) }
      let(:s3) { Pareto::Solution.new(objectives: [], constraints: [-1.0]) }

      it { expect(AggregateConstraintComparator.call(s1, s2)).to be < 0 }
      it { expect(AggregateConstraintComparator.call(s1, s3)).to be < 0 }
      it { expect(AggregateConstraintComparator.call(s2, s1)).to be > 0 }
      it { expect(AggregateConstraintComparator.call(s3, s1)).to be > 0 }
    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new(objectives: [], constraints: [0.0]) }
      let(:s2) { Pareto::Solution.new(objectives: [], constraints: [0.0]) }
      let(:s3) { Pareto::Solution.new(objectives: [], constraints: [1.0]) }
      let(:s4) { Pareto::Solution.new(objectives: [], constraints: [-1.0]) }

      it { expect(AggregateConstraintComparator.call(s1, s2)).to eq 0 }
      it { expect(AggregateConstraintComparator.call(s2, s1)).to eq 0 }
      it { expect(AggregateConstraintComparator.call(s3, s4)).to eq 0 }
      it { expect(AggregateConstraintComparator.call(s4, s3)).to eq 0 }
    end
  end

  describe ParetoObjectiveComparator do
    describe 'dominance' do
      let(:s1) { Pareto::Solution.new(objectives: [0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new(objectives: [0.0, 0.0, 0.0]) }
      let(:s3) { Pareto::Solution.new(objectives: [0.5, 0.0, 0.5]) }

      it { expect(ParetoObjectiveComparator.call(s1, s2)).to be > 0 }
      it { expect(ParetoObjectiveComparator.call(s1, s3)).to be > 0 }
      it { expect(ParetoObjectiveComparator.call(s2, s1)).to be < 0 }
      it { expect(ParetoObjectiveComparator.call(s3, s1)).to be < 0 }
    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new(objectives: [0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new(objectives: [0.5, 0.0, 1.0]) }

      it { expect(ParetoObjectiveComparator.call(s1, s2)).to eq 0 }
      it { expect(ParetoObjectiveComparator.call(s2, s1)).to eq 0 }
    end

    describe 'equals' do
      let(:s1) { Pareto::Solution.new(objectives: [0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new(objectives: [0.5, 0.5, 0.5]) }

      it { expect(ParetoObjectiveComparator.call(s1, s2)).to eq 0 }
      it { expect(ParetoObjectiveComparator.call(s2, s1)).to eq 0 }
    end
  end

  describe ParetoDominanceComparator do
    describe 'dominance' do
      let(:s1) { Pareto::Solution.new(objectives: [0.0, 0.0], constraints: [1.0]) }
      let(:s2) { Pareto::Solution.new(objectives: [1.0, 1.0], constraints: [0.0]) }
      let(:s3) { Pareto::Solution.new(objectives: [1.0, 0.0], constraints: [0.0]) }

      it { expect(ParetoDominanceComparator.call(s1, s2)).to be > 0 }
      it { expect(ParetoDominanceComparator.call(s2, s1)).to be < 0 }
      it { expect(ParetoDominanceComparator.call(s1, s3)).to be > 0 }
      it { expect(ParetoDominanceComparator.call(s3, s1)).to be < 0 }
      it { expect(ParetoDominanceComparator.call(s2, s3)).to be > 0 }
      it { expect(ParetoDominanceComparator.call(s3, s2)).to be < 0 }
    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new(objectives: [0.75, 0.25], constraints: [1.0]) }
      let(:s2) { Pareto::Solution.new(objectives: [0.25, 0.75], constraints: [1.0]) }

      it { expect(ParetoDominanceComparator.call(s1, s2)).to eq 0 }
      it { expect(ParetoDominanceComparator.call(s2, s1)).to eq 0 }
    end
  end

  describe CrowdingComparator do
    context 'dominance' do
      let(:s1) { Pareto::Solution.new(crowding_distance: 1.0 / 0.0) }
      let(:s2) { Pareto::Solution.new(crowding_distance: 0.0) }
      let(:s3) { Pareto::Solution.new(crowding_distance: 1.0) }

      it { expect(CrowdingComparator.call(s1, s2)).to be < 0 }
      it { expect(CrowdingComparator.call(s2, s1)).to be > 0 }
      it { expect(CrowdingComparator.call(s3, s2)).to be < 0 }
      it { expect(CrowdingComparator.call(s2, s3)).to be > 0 }
    end

    context 'nondominance' do
      let(:s1) { Pareto::Solution.new(crowding_distance: 1.0 / 0.0) }
      let(:s2) { Pareto::Solution.new(crowding_distance: 1.0 / 0.0) }
      let(:s3) { Pareto::Solution.new(crowding_distance: 1.0) }
      let(:s4) { Pareto::Solution.new(crowding_distance: 1.0) }

      it { expect(CrowdingComparator.call(s1, s2)).to eq 0 }
      it { expect(CrowdingComparator.call(s2, s1)).to eq 0 }

      it { expect(CrowdingComparator.call(s3, s4)).to eq 0 }
      it { expect(CrowdingComparator.call(s4, s3)).to eq 0 }
    end
  end

  describe RankComparator do
    context 'dominance' do
      let(:s1) { Pareto::Solution.new(rank: 0) }
      let(:s2) { Pareto::Solution.new(rank: 1) }

      it { expect(RankComparator.call(s1, s2)).to be < 0 }
      it { expect(RankComparator.call(s2, s1)).to be > 0 }
    end

    context 'nondominance' do
      let(:s1) { Pareto::Solution.new(rank: 0) }
      let(:s2) { Pareto::Solution.new(rank: 0) }

      it { expect(RankComparator.call(s1, s2)).to eq 0 }
      it { expect(RankComparator.call(s2, s1)).to eq 0 }
    end
  end

  describe NondominatedSortingComparator do
    context 'dominance' do
      let(:s1) { Pareto::Solution.new(rank: 0) }
      let(:s2) { Pareto::Solution.new(rank: 1) }
      let(:s3) { Pareto::Solution.new(rank: 0, crowding_distance: 0) }
      let(:s4) { Pareto::Solution.new(rank: 0, crowding_distance: 1) }

      it { expect(NondominatedSortingComparator.call(s1, s2)).to be < 0 }
      it { expect(NondominatedSortingComparator.call(s2, s1)).to be > 0 }
      it { expect(NondominatedSortingComparator.call(s3, s4)).to be > 0 }
      it { expect(NondominatedSortingComparator.call(s4, s3)).to be < 0 }
    end

    context 'nondominance' do
      let(:s1) { Pareto::Solution.new(rank: 0) }
      let(:s2) { Pareto::Solution.new(rank: 0) }

      it { expect(NondominatedSortingComparator.call(s1, s2)).to eq 0 }
      it { expect(NondominatedSortingComparator.call(s2, s1)).to eq 0 }
    end
  end
end
