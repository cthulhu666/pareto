require 'spec_helper'

module Pareto
  module Algorithms
    describe SPEA2 do

      before(:each) do
        SPEA2.send(:public, *SPEA2.protected_instance_methods)
      end

      let(:algorithm) { SPEA2.new(problem: nil, initialization: nil, variation: nil, number_of_offspring: nil, k: 1) }

      describe '#compute_distance_matrix' do

        context 'with random objectives' do
          let :population do
            Population.new(Array.new(5) { Solution.new(objectives: 3.times.map { rand }) })
          end

          let(:matrix) { SPEA2.compute_distance_matrix(population) }

          it { expect(matrix[0, 0]).to eq 0 }
          it { expect(matrix[2, 0]).to eq matrix[0, 2] }
        end

        context 'with test objectives' do
          let :population do
            Population.new([
                               Solution.new(objectives: [0.0, 1.0]),
                               Solution.new(objectives: [1.0, 0.0]),
                               Solution.new(objectives: [0.5, 0.5])
                           ])
          end

          let(:matrix) { SPEA2.compute_distance_matrix(population) }

          it { expect(matrix[0, 0]).to eq 0 }
          it { expect(matrix[1, 1]).to eq 0 }
          it { expect(matrix[2, 2]).to eq 0 }

          it { expect(matrix[0, 1]).to eq 2.0**0.5 }
          it { expect(matrix[1, 0]).to eq 2.0**0.5 }

          it { expect(matrix[0, 2]).to eq 0.5**0.5 }
          it { expect(matrix[2, 0]).to eq 0.5**0.5 }
          it { expect(matrix[1, 2]).to eq 0.5**0.5 }
          it { expect(matrix[2, 1]).to eq 0.5**0.5 }

        end

      end

      describe '#truncate' do

        let(:s1) { Solution.new(objectives: [0.0, 1.0]) }
        let(:s2) { Solution.new(objectives: [1.0, 0.0]) }
        let(:s3) { Solution.new(objectives: [0.5, 0.5]) }
        let(:population) { Population.new([s1, s2, s3]) }
        let(:result) { algorithm.truncate(population, 2) }
        before(:each) { algorithm.fitness_evaluator.evaluate(population) }

        it { expect(result.size).to eq 2 }
        it { expect(result).to include s1 }
        it { expect(result).to include s2 }
        it { expect(result).to_not include s3 }

      end

      describe SPEA2::StrengthFitnessEvaluator do

        let(:evaluator) { SPEA2::StrengthFitnessEvaluator.new(1) }

        let(:s1) { Solution.new(objectives: [0.0, 0.0]) }
        let(:s2) { Solution.new(objectives: [1.0, 0.0]) }
        let(:s3) { Solution.new(objectives: [0.5, 0.5]) }
        let(:population) { Population.new([s1, s2, s3]) }

        before { evaluator.calculate_strength(population) }

        describe '#calculate_strength' do

          it { expect(s1.strength).to eq 2 }
          it { expect(s2.strength).to eq 0 }
          it { expect(s3.strength).to eq 0 }

        end

        describe '#calculate_raw_fitness' do

          before { evaluator.calculate_raw_fitness(population) }

          it { expect(s1.fitness).to eq 0 }
          it { expect(s2.fitness).to eq 2 }
          it { expect(s3.fitness).to eq 2 }

        end

      end

    end
  end
end
