require 'pathname'
require 'colorize'

require_relative 'analyzer'

module Fasterer
  class FileTraverser
    def initialize(path)
      @path = Pathname(path)
      @parse_error_paths = []
    end

    def traverse
      if @path.directory?
        traverse_directory(@path)
      else
        scan_file(@path)
      end
      output_parse_errors if parse_error_paths.any?
    end

    private

    attr_reader :parse_error_paths

    def scan_file(path)
      analyzer = Analyzer.new(path)
      analyzer.scan
    rescue Fasterer::ParseError, RubyParser::SyntaxError, Racc::ParseError
      parse_error_paths.push(path)
    else
      output(analyzer) if analyzer.errors.any?
    end

    def traverse_directory(path)
      Dir["#{path}/**/*.rb"].each do |ruby_file|
        scan_file(ruby_file.split('/').drop(1).join('/'))
      end
    end

    def output(analyzer)
      puts analyzer.file_path.colorize(:red)
      analyzer.errors.group_by(&:explanation).each do |error_group_explanation, error_occurences|
        puts "#{error_group_explanation}. Occured at lines: #{error_occurences.map(&:line_number).join(', ')}."
      end

      puts
    end

    def output_parse_errors
      puts 'Fasterer was unable to process some files because the'
      puts 'internal parser is not able to read some characters.'
      puts 'Unprocessable files were:'
      puts '-----------------------------------------------------'
      puts parse_error_paths
      puts
    end
  end
end
