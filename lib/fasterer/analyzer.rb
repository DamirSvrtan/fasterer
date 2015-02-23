require 'ripper'
require 'pry'
require 'fasterer/method_definition'
require 'fasterer/method_call'
require 'fasterer/rescue_call'
require 'fasterer/parser'
require 'fasterer/parse_error'

module Fasterer
  class Analyzer

    attr_reader :file_path
    alias_method :path, :file_path

    def initialize(file_path)
      @file_path = file_path
      @file_content = File.read(file_path)
    end

    def scan
      sexp_tree = Fasterer::Parser.parse(@file_content)
      raise ParseError.new(file_path) if sexp_tree.nil?
      scan_sexp_tree(sexp_tree)
    end

    def error_occurrence
      @error_occurrence ||= Hash.new(0)
    end

    private

    def scan_sexp_tree(sexp_tree)
      sexp_tree.each do |element|
        next unless element.kind_of?(Array)
        token = element.first

        case token
        when :def
          scan_method_definitions(element)
          scan_sexp_tree(element)
        when :call, :method_add_block, :method_add_arg, :command_call, :command
          method_call = scan_method_calls(element)
          scan_sexp_tree(method_call.receiver_element)
          scan_sexp_tree(method_call.arguments_element)
          scan_sexp_tree(method_call.block_body) if method_call.has_block?
        when :massign
          scan_parallel_assignment(element)
          scan_sexp_tree(element)
        when :for
          scan_for_loop(element)
          scan_sexp_tree(element)
        when :rescue
          scan_rescue(element)
          scan_sexp_tree(element)
        else
          scan_sexp_tree(element)
        end
      end
    end

    def scan_method_definitions(element)
      method_definition = MethodDefinition.new(element)
      return unless method_definition.has_block?

      # Detect block.call
      traverse_tree(method_definition.body) do |element|
        token = element.first
        next unless token == :call

        method_call = MethodCall.new(element)

        if method_call.receiver.is_a?(Fasterer::VariableReference) &&
          method_call.receiver.name == method_definition.block_argument_name &&
          method_call.method_name == 'call'

          error_occurrence[:proc_call_vs_yield] += 1
          return
        end
      end

    end

    def traverse_tree(sexp_tree, &block)
      sexp_tree.each do |element|
        next unless element.kind_of?(Array)
        block.call(element)
        traverse_tree(element, &block)
      end
    end

    def scan_method_calls(element)
      method_call = MethodCall.new(element)

      case method_call.method_name
      when 'module_eval'
        error_occurrence[:module_eval] += 1
      when 'gsub'
        unless method_call.arguments.first.type == :regexp_literal
          error_occurrence[:gsub_vs_tr] += 1
        end
      when 'sort'
        if method_call.arguments.count > 0 || method_call.has_block?
          error_occurrence[:sort_vs_sort_by] += 1
        end
      when 'each_with_index'
        error_occurrence[:each_with_index_vs_while] += 1
      when 'first'
        return method_call unless method_call.receiver.is_a?(MethodCall)
        case method_call.receiver.name
        when 'shuffle'
          error_occurrence[:shuffle_first_vs_sample] += 1
        when 'select'
          error_occurrence[:select_first_vs_detect] += 1
        end
      when 'each'
        return method_call unless method_call.receiver.is_a?(MethodCall)
        case method_call.receiver.name
        when 'reverse'
          error_occurrence[:reverse_each_vs_reverse_each] += 1
        when 'keys'
          error_occurrence[:keys_each_vs_each_key] += 1
        end
      when 'flatten'
        return method_call unless method_call.receiver.is_a?(MethodCall)
        if method_call.receiver.name == 'map' && method_call.arguments.count == 1 && method_call.arguments.first.value == "1"
          error_occurrence[:map_flatten_vs_flat_map] += 1
        end
      end

      method_call
    end

    def scan_parallel_assignment(element)
      error_occurrence[:parallel_assignment] += 1
    end

    def scan_for_loop(element)
      error_occurrence[:for_loop_vs_each] += 1
    end

    def scan_rescue(element)
      rescue_call = RescueCall.new(element)
      if rescue_call.rescue_classes.include? 'NoMethodError'
        error_occurrence[:rescue_vs_respond_to] += 1
      end
    end

  end
end
