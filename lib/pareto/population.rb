module Pareto
  class Population
    include Enumerable

    def initialize(solutions = Array.new)
      @data = solutions
    end

    def [](i)
      @data[i]
    end

    def add(solution)
      @data << solution
      self
    end

    def add_all(solutions)
      solutions.each { |s| add(s) }
      self
    end

    def size
      @data.size
    end

    def truncate(size, comparator)
      @data.sort! &comparator
      @data = @data[0...size]
    end

    def each &block
      @data.each &block
    end

    def sort! &block
      @data.sort! &block
    end

    def sample
      @data.sample
    end

  end
end
