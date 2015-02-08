module Fasterer
  class CommandCall

    def initialize(element)
      @element = element
    end

    def name
      @element[1][1]
    end

  end
end
