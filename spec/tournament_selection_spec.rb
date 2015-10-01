require 'spec_helper'

module Pareto
  describe TournamentSelection do

    let(:selection) { TournamentSelection.new }

    before(:each) do
      TournamentSelection.send(:public, *TournamentSelection.protected_instance_methods)
    end

    describe '#select' do

      let(:s1) { Solution.new(objectives: [1]) }
      let(:s2) { Solution.new(objectives: [2]) }
      let(:s3) { Solution.new(objectives: [3]) }

      let(:pop) { Population.new([s1, s2, s3]) }

      let(:numbers) do
        100.times.inject(Hash.new(0)) { |h, i| h[selection.select_one(pop)] +=1; h }
      end

      it { expect(numbers[s1]).to be > numbers[s2] }
      it { expect(numbers[s2]).to be > numbers[s3] }

    end

  end
end
