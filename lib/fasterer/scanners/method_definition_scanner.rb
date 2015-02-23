require 'fasterer/method_definition'
require 'fasterer/method_call'
require 'fasterer/offense'
require 'fasterer/scanners/offensive'

module Fasterer
  class MethodDefinitionScanner
    include Fasterer::Offensive

    attr_reader :element

    def initialize(element)
      @element = element
      check_offense
    end

    private

    def check_offense
      if method_definition.has_block?
        scan_block_call_offense
      end
    end

    def scan_block_call_offense
      traverse_tree(method_definition.body) do |element|
        next unless element.sexp_type == :call

        method_call = MethodCall.new(element)

        if method_call.receiver.is_a?(Fasterer::VariableReference) &&
          method_call.receiver.name == method_definition.block_argument_name &&
          method_call.method_name == :call

          add_offense(:proc_call_vs_yield) && return
        end
      end
    end

    def method_definition
      @method_definition ||= MethodDefinition.new(element)
    end

    def traverse_tree(sexp_tree, &block)
      sexp_tree.each do |element|
        next unless element.is_a?(Array)
        yield element
        traverse_tree(element, &block)
      end
    end
  end
end
