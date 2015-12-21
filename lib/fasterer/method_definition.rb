module Fasterer
  class MethodDefinition
    attr_reader :element # for testing purposes
    attr_reader :method_name
    attr_reader :block_argument_name
    attr_reader :body
    attr_reader :arguments

    alias_method :name, :method_name

    def initialize(element)
      @element = element # Ripper element
      set_method_name
      set_body
      set_arguments
      set_block_argument_name
    end

    def has_block?
      !!@block_argument_name
    end

    def setter?
      name.to_s.end_with?('=')
    end

    private

    def arguments_element
      element[2].drop(1) || []
    end

    def set_method_name
      @method_name = @element[1]
    end

    def set_arguments
      @arguments = arguments_element.map do |argument_element|
        MethodDefinitionArgument.new(argument_element)
      end
    end

    def set_body
      @body = @element[3..-1]
    end

    def set_block_argument_name
      if last_argument_element.to_s.start_with?('&')
        @block_argument_name = last_argument_element.to_s[1..-1].to_sym
      end
    end

    def last_argument_element
      arguments_element.last
    end
  end

  class MethodDefinitionArgument
    attr_reader :element, :name, :type

    def initialize(element)
      @element = element
      set_name
      set_argument_type
    end

    def regular_argument?
      @type == :regular_argument
    end

    def default_argument?
      @type == :default_argument
    end

    def keyword_argument?
      @type == :keyword_argument
    end

    private

    def set_name
      @name = element.is_a?(Symbol) ? element : element[1]
    end

    def set_argument_type
      @type = if element.is_a?(Symbol)
                :regular_argument
              elsif element.is_a?(Sexp) && element.sexp_type == :lasgn
                :default_argument
              elsif element.is_a?(Sexp) && element.sexp_type == :kwarg
                :keyword_argument
      end
    end
  end
end
