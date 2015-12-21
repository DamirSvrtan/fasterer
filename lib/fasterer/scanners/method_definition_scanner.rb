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
      else
        scan_getter_and_setter_offense
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

    def scan_getter_and_setter_offense
      method_definition.setter? ? scan_setter_offense : scan_getter_offense
    end

    def scan_setter_offense
      return if method_definition.arguments.size != 1
      return if method_definition.body.size != 1

      first_argument = method_definition.arguments.first
      return if first_argument.type != :regular_argument

      if method_definition.body.first.sexp_type == :iasgn &&
         method_definition.body.first[1].to_s == "@#{method_definition.name.to_s[0..-2]}" &&
         method_definition.body.first[2][1] == first_argument.name

        add_offense(:setter_vs_attr_writer)
      end
    end

    def scan_getter_offense
      return if method_definition.arguments.size > 0
      return if method_definition.body.size != 1

      if method_definition.body.first.sexp_type == :ivar &&
         method_definition.body.first[1].to_s == "@#{method_definition.name}"

        add_offense(:getter_vs_attr_reader)
      end
    end
  end
end
