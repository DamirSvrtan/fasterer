require 'fasterer/offense'

module Fasterer
  module Offensive
    def add_offense(offense_name, element_line_number = element.line)
      self.offense = Fasterer::Offense.new(offense_name, element_line_number)
    end
  end
end
