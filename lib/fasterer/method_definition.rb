module Fasterer
  class MethodDefinition
    attr_reader :element # for testing purposes
    attr_reader :method_name
    attr_reader :block_argument_name
    attr_reader :body

    def initialize(element)
      @element = element # Ripper element
      set_method_name
      set_body

      if arguments_element.any?
        set_argument_names
        set_block_argument_name
      end
    end

    def has_block?
      !!@block_argument_name
    end

    private

    def arguments_element
      element[2].drop(1)
    end

    def set_method_name
      @method_name = @element[1]
    end

    def set_argument_names
      # TODO
    end

    def set_body
      @body = @element[3..-1]
    end

    def set_block_argument_name
      if last_argument.to_s.start_with?('&')
        @block_argument_name = last_argument.to_s[1..-1].to_sym
      end
    end

    def last_argument
      arguments_element.last
    end
  end
end
