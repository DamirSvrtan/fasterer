require 'fasterer/rescue_call'
require 'fasterer/offense'
require 'fasterer/scanners/offensive'

module Fasterer
  class RescueCallScanner
    include Fasterer::Offensive

    attr_reader :element

    def initialize(element)
      @element = element
      check_offense
    end

    private

    def check_offense
      if rescue_call.rescue_classes.include? :NoMethodError
        add_offense(:rescue_vs_respond_to)
      end
    end

    def rescue_call
      @rescue_call ||= RescueCall.new(element)
    end
  end
end
