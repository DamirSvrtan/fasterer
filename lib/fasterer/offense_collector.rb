require 'forwardable'

module Fasterer
  class OffenseCollector
    extend Forwardable

    def initialize
      @offenses = []
    end

    def [](offense_name)
      @offenses.select { |offense| offense.name == offense_name }
    end

    def_delegators :@offenses, :push, :any?, :each, :group_by, :count
  end
end
