module Pareto
  module Operators

    # http://www.slideshare.net/paskorn/self-adaptive-simulated-binary-crossover-presentation
    class SimulatedBinaryCrossover

      attr_reader :probability

      def initialize(probability: 0.90, distribution_index: 2.0)
        @probability = probability
        @distribution_index = distribution_index
      end

      def evolve(parents)
        n = parents.first.number_of_variables
        children = parents.map &:dup

        if rand <= probability
          n.times do |i|
            evolve_variables(children.first.variables[i], children.last.variables[i], @distribution_index)
          end
        end

        children
      end


      def evolve_variables(v1, v2, distribution_index)
        x0, x1 = v1.value, v2.value
        dx = (x1 - x0).abs

        if dx > Pareto::EPS

          lb = v1.bounds.begin
          ub = v1.bounds.end
          bl = nil
          bu = nil

          if x0 < x1
            bl = 1 + 2 * (x0 - lb) / dx
            bu = 1 + 2 * (ub - x1) / dx
          else
            bl = 1 + 2 * (x1 - lb) / dx
            bu = 1 + 2 * (ub - x0) / dx
          end

          # use symmetric distributions
          if bl < bu
            bu = bl
          else
            bl = bu
          end

          p_bl = 1 - 1 / (2 * (bl ** (distribution_index + 1)))
          p_bu = 1 - 1 / (2 * (bu ** (distribution_index + 1)))

          u = rand

          # prevent out-of-bounds values if PRNG draws the value 1.0
          u = u.prev_float if u == 1.0

          u0 = u * p_bl
          u1 = u * p_bu
          b0 = nil
          b1 = nil

          if u0 <= 0.5
            b0 = (2 * u0) ** (1 / (distribution_index + 1))
          else
            b0 = (0.5 / (1 - u0)) ** (1 / (distribution_index + 1))
          end

          if u1 <= 0.5
            b1 = (2 * u1) ** (1 / (distribution_index + 1))
          else
            b1 = (0.5 / (1 - u1)) ** (1 / (distribution_index + 1))
          end

          if x0 < x1
            v1.value = (0.5 * (x0 + x1 + b0 * (x0 - x1)))
            v2.value = (0.5 * (x0 + x1 + b1 * (x1 - x0)))
          else
            v1.value = (0.5 * (x0 + x1 + b1 * (x0 - x1)))
            v2.value = (0.5 * (x0 + x1 + b0 * (x1 - x0)))
          end


          if rand > 0.5
            temp = v1.value
            v1.value = v2.value
            v2.value = temp
          end

          if v1.value < lb
            v1.value = lb
          elsif v1.value > ub
            v1.value = ub
          end

          if v2.value < lb
            v2.value = lb
          elsif v2.value > ub
            v2.value = ub
          end
        end

      end

      protected :evolve_variables
    end
  end
end
