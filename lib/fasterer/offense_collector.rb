module Fasterer
  class OffenseCollector

    def initialize
      @offenses = []
    end

    def push(offense)
      @offenses.push(offense)
    end

    def [](offense_name)
      @offenses.select { |offense| offense.name == offense_name }
    end

  end
end
