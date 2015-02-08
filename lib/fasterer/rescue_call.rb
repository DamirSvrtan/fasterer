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
        case element.drop(1).flatten.first
        when :mrhs_new_from_args
          set_multiple_rescue_classes
        when :var_ref
          set_single_rescue_class
        when nil
          @rescue_classes = []
        end
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
