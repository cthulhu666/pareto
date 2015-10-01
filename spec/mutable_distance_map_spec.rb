require 'spec_helper'

module Pareto
  module Algorithms

    describe SPEA2::MutableDistanceMap do


      context 'data set 1' do

        let(:raw_distance_matrix) { [
            [0, 1.0, 0.5**0.5],
            [1.0, 0, 0.5**0.5],
            [0.5**0.5, 0.5**0.5, 0]] }

        let(:distance_matrix) { [
            [[2, 0.7071067811865476], [1, 1.0]],
            [[2, 0.7071067811865476], [0, 1.0]],
            [[0, 0.7071067811865476], [1, 0.7071067811865476]]
        ] }

        let(:map) { SPEA2::MutableDistanceMap.new(raw_distance_matrix) }

        describe '#init' do
          it { expect(map.matrix).to eq distance_matrix }
        end

        describe '#remove_point' do
          pending
        end

      end


      context 'data set 2' do

        let(:raw_distance_matrix) { [
            [0.0, 1.4142135623730951, 0.7071067811865476],
            [1.4142135623730951, 0.0, 0.7071067811865476],
            [0.7071067811865476, 0.7071067811865476, 0.0]] }

        let(:distance_matrix) { [
            [[2, 0.7071067811865476], [1, 1.4142135623730951]],
            [[2, 0.7071067811865476], [0, 1.4142135623730951]],
            [[0, 0.7071067811865476], [1, 0.7071067811865476]]
        ] }

        let(:map) { SPEA2::MutableDistanceMap.new(raw_distance_matrix) }

        describe '#init' do
          it { expect(map.matrix).to eq distance_matrix }
        end

        describe '#find_most_crowded_point' do
          it { expect(map.find_most_crowded_point).to eq 2 }
        end

        describe '#remove_point' do
          it {
            map.remove_point(2)
            expect(map.matrix).to eq [[[1, 1.4142135623730951]], [[0, 1.4142135623730951]]]
          }
        end

      end

    end

  end
end
