module Fasterer
  class RescueCall
    attr_reader :element
    attr_reader :rescue_classes

    def initialize(element)
      @element = element
      @rescue_classes = []
      set_rescue_classes
    end

    private

    def set_rescue_classes
      return if element[1].sexp_type != :array

      @rescue_classes = element[1].drop(1).map do |rescue_reference|
        if rescue_reference.sexp_type == :const
          rescue_reference[1]
        end
      end.compact
    end

    def set_multiple_rescue_classes
      @rescue_classes = element[1].drop(1).map do |rescue_reference|
        rescue_reference.flatten[2]
      end
    end

    def set_single_rescue_class
      if element[1][0][0] == :var_ref
        @rescue_classes = Array(element[1][0][1][1])
      end
    end
  end
end
