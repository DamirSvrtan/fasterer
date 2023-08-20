require 'fasterer/method_call'
require 'fasterer/offense'
require 'fasterer/scanners/offensive'

module Fasterer
  class MethodCallScanner
    include Fasterer::Offensive

    attr_reader :element

    def initialize(element)
      @element = element
      check_offense
    end

    def method_call
      @method_call ||= MethodCall.new(element)
    end

    private

    def check_offense
      case method_call.method_name
      when :module_eval
        check_module_eval_offense
      when :gsub
        check_gsub_offense
      when :sort
        check_sort_offense
      when :each_with_index
        check_each_with_index_offense
      when :first
        check_first_offense
      when :each
        check_each_offense
      when :flatten
        check_flatten_offense
      when :fetch
        check_fetch_offense
      when :merge!
        check_merge_bang_offense
      when :last
        check_last_offense
      when :include?
        check_range_include_offense
      end

      check_symbol_to_proc
    end

    def check_module_eval_offense
      first_argument = method_call.arguments.first
      return unless first_argument && first_argument.value.is_a?(String)

      add_offense(:module_eval) if first_argument.value.include?('def')
    end

    def check_gsub_offense
      first_argument  = method_call.arguments[0]
      second_argument = method_call.arguments[1]

      return if first_argument.nil? || second_argument.nil?

      if first_argument.value.is_a?(String) && first_argument.value.size == 1 &&
         second_argument.value.is_a?(String) && second_argument.value.size == 1

        add_offense(:gsub_vs_tr)
      end
    end

    def check_sort_offense
      if method_call.arguments.count > 0 || method_call.has_block?
        add_offense(:sort_vs_sort_by)
      end
    end

    def check_each_with_index_offense
      add_offense(:each_with_index_vs_while)
    end

    def check_first_offense
      return method_call unless method_call.receiver.is_a?(MethodCall)

      case method_call.receiver.name
      when :shuffle
        add_offense(:shuffle_first_vs_sample)
      when :select
        return unless method_call.receiver.has_block?
        return if method_call.arguments.count > 0

        add_offense(:select_first_vs_detect)
      end
    end

    def check_each_offense
      return method_call unless method_call.receiver.is_a?(MethodCall)

      case method_call.receiver.name
      when :reverse
        add_offense(:reverse_each_vs_reverse_each)
      when :keys
        if method_call.receiver.arguments.count.zero?
          add_offense(:keys_each_vs_each_key)
        end
      end
    end

    def check_flatten_offense
      return method_call unless method_call.receiver.is_a?(MethodCall)

      if method_call.receiver.name == :map &&
         method_call.arguments.count == 1 &&
         method_call.arguments.first.value == 1

        add_offense(:map_flatten_vs_flat_map)
      end
    end

    def check_fetch_offense
      if method_call.arguments.count == 2 && !method_call.has_block?
        add_offense(:fetch_with_argument_vs_block)
      end
    end

    # Need to refactor, fukken complicated conditions.
    def check_symbol_to_proc
      return unless method_call.block_argument_names.count == 1
      return if method_call.block_body.nil?
      return unless method_call.block_body.sexp_type == :call
      return if method_call.arguments.count > 0
      return if method_call.lambda_literal?

      body_method_call = MethodCall.new(method_call.block_body)

      return unless body_method_call.arguments.count.zero?
      return if body_method_call.has_block?
      return if body_method_call.receiver.nil?
      return if body_method_call.receiver.is_a?(Fasterer::Primitive)
      return if body_method_call.receiver.name != method_call.block_argument_names.first

      add_offense(:block_vs_symbol_to_proc)
    end

    def check_merge_bang_offense
      return unless method_call.arguments.count == 1

      first_argument = method_call.arguments.first
      return unless first_argument.type == :hash

      if first_argument.element.drop(1).count == 2 # each key and value is an item by itself.
        add_offense(:hash_merge_bang_vs_hash_brackets)
      end
    end

    def check_last_offense
      return method_call unless method_call.receiver.is_a?(MethodCall)

      case method_call.receiver.name
      when :select
        add_offense(:select_last_vs_reverse_detect)
      end
    end

    def check_range_include_offense
      if method_call.receiver.is_a?(Primitive) && method_call.receiver.range?
        add_offense(:include_vs_cover_on_range)
      end
    end
  end
end
