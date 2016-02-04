require 'spec_helper'

describe Pareto do
  describe Pareto::AggregateConstraintComparator do
    describe 'dominance' do
      let(:s1) { Pareto::Solution.new(objectives: [], constraints: [0.0]) }
      let(:s2) { Pareto::Solution.new(objectives: [], constraints: [1.0]) }
      let(:s3) { Pareto::Solution.new(objectives: [], constraints: [-1.0]) }

      it { expect(Pareto::AggregateConstraintComparator.call(s1, s2)).to be < 0 }
      it { expect(Pareto::AggregateConstraintComparator.call(s1, s3)).to be < 0 }
      it { expect(Pareto::AggregateConstraintComparator.call(s2, s1)).to be > 0 }
      it { expect(Pareto::AggregateConstraintComparator.call(s3, s1)).to be > 0 }
    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new(objectives: [], constraints: [0.0]) }
      let(:s2) { Pareto::Solution.new(objectives: [], constraints: [0.0]) }
      let(:s3) { Pareto::Solution.new(objectives: [], constraints: [1.0]) }
      let(:s4) { Pareto::Solution.new(objectives: [], constraints: [-1.0]) }

      it { expect(Pareto::AggregateConstraintComparator.call(s1, s2)).to eq 0 }
      it { expect(Pareto::AggregateConstraintComparator.call(s2, s1)).to eq 0 }
      it { expect(Pareto::AggregateConstraintComparator.call(s3, s4)).to eq 0 }
      it { expect(Pareto::AggregateConstraintComparator.call(s4, s3)).to eq 0 }
    end
  end

  describe Pareto::ParetoObjectiveComparator do
    describe 'dominance' do
      let(:s1) { Pareto::Solution.new(objectives: [0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new(objectives: [0.0, 0.0, 0.0]) }
      let(:s3) { Pareto::Solution.new(objectives: [0.5, 0.0, 0.5]) }

      it { expect(Pareto::ParetoObjectiveComparator.call(s1, s2)).to be > 0 }
      it { expect(Pareto::ParetoObjectiveComparator.call(s1, s3)).to be > 0 }
      it { expect(Pareto::ParetoObjectiveComparator.call(s2, s1)).to be < 0 }
      it { expect(Pareto::ParetoObjectiveComparator.call(s3, s1)).to be < 0 }
    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new(objectives: [0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new(objectives: [0.5, 0.0, 1.0]) }

      it { expect(Pareto::ParetoObjectiveComparator.call(s1, s2)).to eq 0 }
      it { expect(Pareto::ParetoObjectiveComparator.call(s2, s1)).to eq 0 }
    end

    describe 'equals' do
      let(:s1) { Pareto::Solution.new(objectives: [0.5, 0.5, 0.5]) }
      let(:s2) { Pareto::Solution.new(objectives: [0.5, 0.5, 0.5]) }

      it { expect(Pareto::ParetoObjectiveComparator.call(s1, s2)).to eq 0 }
      it { expect(Pareto::ParetoObjectiveComparator.call(s2, s1)).to eq 0 }
    end
  end

  describe Pareto::ParetoDominanceComparator do
    describe 'dominance' do
      let(:s1) { Pareto::Solution.new(objectives: [0.0, 0.0], constraints: [1.0]) }
      let(:s2) { Pareto::Solution.new(objectives: [1.0, 1.0], constraints: [0.0]) }
      let(:s3) { Pareto::Solution.new(objectives: [1.0, 0.0], constraints: [0.0]) }

      it { expect(Pareto::ParetoDominanceComparator.call(s1, s2)).to be > 0 }
      it { expect(Pareto::ParetoDominanceComparator.call(s2, s1)).to be < 0 }
      it { expect(Pareto::ParetoDominanceComparator.call(s1, s3)).to be > 0 }
      it { expect(Pareto::ParetoDominanceComparator.call(s3, s1)).to be < 0 }
      it { expect(Pareto::ParetoDominanceComparator.call(s2, s3)).to be > 0 }
      it { expect(Pareto::ParetoDominanceComparator.call(s3, s2)).to be < 0 }
    end

    describe 'nondominance' do
      let(:s1) { Pareto::Solution.new(objectives: [0.75, 0.25], constraints: [1.0]) }
      let(:s2) { Pareto::Solution.new(objectives: [0.25, 0.75], constraints: [1.0]) }

      it { expect(Pareto::ParetoDominanceComparator.call(s1, s2)).to eq 0 }
      it { expect(Pareto::ParetoDominanceComparator.call(s2, s1)).to eq 0 }
    end
  end

  describe Pareto::CrowdingComparator do
    context 'dominance' do
      let(:s1) { s = Pareto::Solution.new; s.crowding_distance = 1.0 / 0.0; s }
      let(:s2) { s = Pareto::Solution.new; s.crowding_distance = 0.0; s }
      let(:s3) { s = Pareto::Solution.new; s.crowding_distance = 1.0; s }

      it { expect(Pareto::CrowdingComparator.call(s1, s2)).to be < 0 }
      it { expect(Pareto::CrowdingComparator.call(s2, s1)).to be > 0 }
      it { expect(Pareto::CrowdingComparator.call(s3, s2)).to be < 0 }
      it { expect(Pareto::CrowdingComparator.call(s2, s3)).to be > 0 }
    end

    context 'nondominance' do
      let(:s1) { s = Pareto::Solution.new; s.crowding_distance = 1.0 / 0.0; s }
      let(:s2) { s = Pareto::Solution.new; s.crowding_distance = 1.0 / 0.0; s }
      let(:s3) { s = Pareto::Solution.new; s.crowding_distance = 1.0; s }
      let(:s4) { s = Pareto::Solution.new; s.crowding_distance = 1.0; s }

      it { expect(Pareto::CrowdingComparator.call(s1, s2)).to eq 0 }
      it { expect(Pareto::CrowdingComparator.call(s2, s1)).to eq 0 }

      it { expect(Pareto::CrowdingComparator.call(s3, s4)).to eq 0 }
      it { expect(Pareto::CrowdingComparator.call(s4, s3)).to eq 0 }
    end
  end

  describe Pareto::RankComparator do
    context 'dominance' do
      let(:s1) { s = Pareto::Solution.new; s.rank = 0; s }
      let(:s2) { s = Pareto::Solution.new; s.rank = 1; s }

      it { expect(Pareto::RankComparator.call(s1, s2)).to be < 0 }
      it { expect(Pareto::RankComparator.call(s2, s1)).to be > 0 }
    end

    context 'nondominance' do
      let(:s1) { s = Pareto::Solution.new; s.rank = 0; s }
      let(:s2) { s = Pareto::Solution.new; s.rank = 0; s }

      it { expect(Pareto::RankComparator.call(s1, s2)).to eq 0 }
      it { expect(Pareto::RankComparator.call(s2, s1)).to eq 0 }
    end
  end
end
