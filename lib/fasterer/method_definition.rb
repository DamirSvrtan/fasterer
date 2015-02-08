module Fasterer
  class MethodDefinition

    attr_reader :element # for testing purposes
    attr_reader :method_name
    # attr_reader :argument_names
    attr_reader :block_argument_name
    attr_reader :body

    def initialize(element)
      @element = element # Ripper element
      set_method_name
      set_argument_names
      set_body
    end

    def has_block?
      !!@block_argument_name
    end

    private

      def set_method_name
        @method_name = @element[1][1]
      end

      def set_argument_names
        parenthesis_tree = @element[2]
        params_tree = parenthesis_tree[1]

        return if params_tree.nil?

        params_tree = params_tree.compact.drop(1) # remove :params and nils

        # TODO: for later, need a way to differantiate regular vs arguments with defaults.
        # set_regular_argument_names(params_tree.first)
        # set_other_argument_names(params_tree.drop(1))

        # @argument_names = @regular_argument_names + [@block_argument_name].compact

        block_param = params_tree.detect { |param| param.first == :blockarg }
        set_block_argument_name(block_param) if block_param
      end

      def set_body
        @body = @element.last[1]
      end

      # def set_regular_argument_names(regular_params)
      #   @regular_argument_names = regular_params.map do |param|
      #     param[1]
      #   end
      # end

      # def set_other_argument_names(other_params)
      #   other_params.each do |param|
      #     case param.first
      #     when :rest_param
      #       set_splat_argument_name(param)
      #     when :blockarg
      #       set_block_argument_name(param)
      #     end
      #   end
      # end

      # def set_splat_argument_name(param)

      # end

      def set_block_argument_name(block_param)
        @block_argument_name = block_param.drop(1).first[1]
      end

  end
end
