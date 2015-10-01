module Pareto
  class RealVariable

    attr_reader :value, :bounds

    def initialize(value: nil, bounds:)
      raise ArgumentError, bounds unless bounds.is_a?(Range)
      @bounds = bounds
      self.value = value if value
    end

    def value=(v)
      raise ArgumentError, v unless bounds.include?(v)
      @value = v.to_f
    end

    def ==(other_var)
      value == other_var.value && bounds == other_var.bounds
    end

  end
end