module Pareto
  class NondominatedSortingPopulation < Population

    attr_reader :fast_nondominated_sorting

    def initialize
      @fast_nondominated_sorting = FastNondominatedSorting.new
      super
    end

    def truncate(size, comparator = NONDOMINATED_SORTING_COMPARATOR)
      update if modified?
      super(size, comparator)
    end

    def add(solution)
      @modified = true
      super
    end

    def update
      @modified = false
      fast_nondominated_sorting.evaluate(self)
    end

    def modified?
      @modified
    end

  end
end
