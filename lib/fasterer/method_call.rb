module Fasterer
  class MethodCall

    attr_reader :element
    attr_reader :receiver
    attr_reader :method_name
    attr_reader :arguments
    attr_reader :block_body

    alias_method :name, :method_name

    def initialize(element)
      @element = element
      set_call_element
      set_receiver
      set_method_name
      set_arguments
      set_block_presence
      set_block_body
    end

    def has_block?
      @block_present || false
    end

    def receiver_element
      call_element[1]
    end

    def arguments_element
      call_element[3..-1] || []
    end

    private

      attr_reader :call_element
      # TODO: explanation
      def set_call_element
        @call_element = case element.sexp_type
                        when :call
                          @element
                        when :iter
                          @element[1]
                        else
                          raise '!!!!!!!'
                        end
      end

      def set_receiver
        @receiver = ReceiverFactory.new(receiver_element)
      end

      def set_method_name
        @method_name = call_element[2]
      end

      def set_arguments
        @arguments = arguments_element.map { |argument| Argument.new(argument) }
      end

      def set_block_presence
        if element.sexp_type == :iter
          @block_present = true
        end
      end

      def set_block_body
        if token == :method_add_block
          @block_body = element[2][2]
        end
      end

      def token
        element[0]
      end

  end

  # For now, used for determening if
  # the receiver is a reference or not.
  class ReceiverFactory
    attr_reader :name
    attr_reader :method

    def self.new(receiver_info)
      return if receiver_info.nil?
      token = receiver_info.first

      case token
      when :lvar
        return VariableReference.new(receiver_info)
      when :method_add_arg, :method_add_block
        case receiver_info[1][0]
        when :call, :fcall
          return MethodCall.new(receiver_info[1])
        else
          # binding.pry watch out for :method_add_arg
          # raise 'nije ni metoda'
        end
      when :call
        return MethodCall.new(receiver_info)
      end
    end
  end

  class VariableReference
    attr_reader :name

    def initialize(reference_info)
      @reference_info = reference_info
      @name = reference_info[1]
    end
  end

  class Argument
    def initialize(element)
      @element = element
    end

    def type
      @type ||= @element[0]
    end

    def value
      @value ||= @element[1]
    end
  end

end
