require 'fasterer/method_call'
require 'fasterer/offense'
module Fasterer
  class MethodCallScanner

    attr_reader :element
    attr_accessor :offense

    def initialize(element)
      @element = element
      check_offense
    end

    def offensive?
      !!offense
    end

    alias_method :offense_detected?, :offensive?

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
        self.offense = Fasterer::Offense.new(:module_eval, element.line)
      end

      def check_gsub_offense
        unless method_call.arguments.first.value.is_a? Regexp
          self.offense = Fasterer::Offense.new(:gsub_vs_tr, element.line)
        end
      end

      def check_sort_offense
        if method_call.arguments.count > 0 || method_call.has_block?
          self.offense = Fasterer::Offense.new(:sort_vs_sort_by, element.line)
        end
      end

      def check_each_with_index_offense
        self.offense = Fasterer::Offense.new(:each_with_index_vs_while, element.line)
      end

      def check_first_offense
        return method_call unless method_call.receiver.is_a?(MethodCall)

        self.offense =  case method_call.receiver.name
                        when :shuffle
                          Fasterer::Offense.new(:shuffle_first_vs_sample, element.line)
                        when :select
                          Fasterer::Offense.new(:select_first_vs_detect, element.line)
                        end
      end

      def check_each_offense
        return method_call unless method_call.receiver.is_a?(MethodCall)

        self.offense =  case method_call.receiver.name
                        when :reverse
                          Fasterer::Offense.new(:reverse_each_vs_reverse_each, element.line)
                        when :keys
                          Fasterer::Offense.new(:keys_each_vs_each_key, element.line)
                        end
      end

      def check_flatten_offense
        return method_call unless method_call.receiver.is_a?(MethodCall)

        if method_call.receiver.name == :map &&
           method_call.arguments.count == 1 &&
           method_call.arguments.first.value == 1

          self.offense = Fasterer::Offense.new(:map_flatten_vs_flat_map, element.line)
        end
      end

      def check_fetch_offense
        if method_call.arguments.count == 2 && !method_call.has_block?
          self.offense = Fasterer::Offense.new(:fetch_with_argument_vs_block, element.line)
        end
      end

  end
end
