require 'spec_helper'
require 'pareto/nondominated_population'

describe Pareto::NondominatedPopulation do

  Solution = Struct.new(:objectives, :constraints) do
    def number_of_objectives
      objectives.size
    end
  end

  let(:pop) { Pareto::NondominatedPopulation.new }

  describe '#distance' do

    let(:s1) { Solution.new([0.0, 1.0, 0.0]) }
    let(:s2) { Solution.new([0.0, 0.0, -1.0]) }

    it { expect(pop.distance(s1, s2)).to eq 2.0**0.5 }
    it { expect(pop.distance(s2, s1)).to eq 2.0**0.5 }
    it { expect(pop.distance(s1, s1)).to eq 0.0 }
    it { expect(pop.distance(s2, s2)).to eq 0.0 }
  end

  describe '#add' do
    let(:s1) { Solution.new([0.0, 0.0, Pareto::EPS / 2.0], []) }
    let(:s2) { Solution.new([0.0, Pareto::EPS / 2.0, 0.0], []) }

    before do
      pop.add s1
      pop.add s2
    end

    it { expect(pop.size).to eq 1 }
    it { expect(pop).to include s1 }
    it { expect(pop).to_not include s2 }


  end

end
