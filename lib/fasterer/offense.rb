module Fasterer
  class Offense

    attr_reader :offense_name, :line_number

    alias_method :name, :offense_name
    alias_method :line, :line_number

    def initialize(offense_name, line_number)
      @offense_name = offense_name
      @line_number  = line_number
    end

  end
end
