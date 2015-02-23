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
      end
    end

    def check_module_eval_offense
      add_offense(:module_eval)
    end

    def check_gsub_offense
      unless method_call.arguments.first.value.is_a? Regexp
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
        add_offense(:select_first_vs_detect)
      end
    end

    def check_each_offense
      return method_call unless method_call.receiver.is_a?(MethodCall)

      case method_call.receiver.name
      when :reverse
        add_offense(:reverse_each_vs_reverse_each)
      when :keys
        add_offense(:keys_each_vs_each_key)
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
  end
end
