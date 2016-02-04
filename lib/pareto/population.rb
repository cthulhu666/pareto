module Pareto
  class Population
    include Enumerable

    def initialize(solutions = [])
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
      @data.sort!(&comparator)
      @data = @data[0...size]
    end

    def each(&block)
      @data.each(&block)
    end

    def sort!(&block)
      @data.sort!(&block)
    end

    def sample
      @data.sample
    end

    def delete_if(&block)
      @data.delete_if(&block)
    end

    def delete_at(i)
      @data.delete_at(i)
    end

    def clear
      @data.clear
    end

    def shift
      @data.shift
    end
  end
end
