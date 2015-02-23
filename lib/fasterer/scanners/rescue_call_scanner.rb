require 'fasterer/rescue_call'
require 'fasterer/offense'

module Fasterer
  class RescueCallScanner

    attr_reader :element
    attr_accessor :offense

    def initialize(element)
      @element = element
      check_offense
    end

    def offensive?
      !!offense
    end

    alias_method :offense_detected?, :offensive?

    private

      def check_offense
        if rescue_call.rescue_classes.include? :NoMethodError
          self.offense = Fasterer::Offense.new(:rescue_vs_respond_to, element.line)
        end
      end

      def rescue_call
        @rescue_call ||= RescueCall.new(element)
      end

  end
end
