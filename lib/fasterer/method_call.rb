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
      case token
      when :method_add_block
        element[1][0] == :call ? element[1][1] : element[1][1][1]
      when :method_add_arg
        element[1][1]
      else # call or command_call
        element[1]
      end
    end

    def arguments_element
      case token
      when :method_add_block
        element[1][2][0] == :arg_paren ? element[1][2][1][1] : []
        # element[1][2][1][1]
      when :method_add_arg
        (element[2][1].nil? ? [] : element[2][1][1]) || [] # need to fix this, if the first argument is a method without braces
      when :command_call
        element.last[1]
      else
        []
      end
    end

    private

      def set_receiver
        @receiver = ReceiverFactory.new(receiver_element)
      end

      def set_method_name
        @method_name = case token
                       when :method_add_arg
                         element[1].last[1]
                       when :method_add_block
                         element[1][0] == :call ? element[1].last[1] : element[1][1].last[1]
                       when :call
                         element.last[1]
                       when :command_call
                         element[3][1]
                       end
      end

      def set_arguments
        @arguments = arguments_element.map { |argument| Argument.new(argument) }
      end

      def set_block_presence
        if token == :method_add_block
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
      token = receiver_info.first

      case token
      when :var_ref
        return VariableReference.new(receiver_info[1])
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
