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
        begin
          analyzer = Analyzer.new(path)
          analyzer.scan
        rescue Fasterer::ParseError => error
          parse_error_paths.push(error.file_path)
        else
          output(analyzer) if analyzer.errors.any?
        end
      end

      def traverse_directory(path)
        Dir["#{path}/**/*.rb"].each do |ruby_file|
          scan_file(ruby_file.split('/').drop(1).join('/'))
        end
      end

      def output(analyzer)
        puts analyzer.file_path.colorize(:red)
        analyzer.errors.each do |error|
          puts "#{error.name}: #{error.line_number}"
        end
        puts
      end

      def output_parse_errors
        puts "Fasterer was unable to process some files because the"
        puts "internal parser is not able to read some characters."
        puts "Unprocessable files were:"
        puts "-----------------------------------------------------"
        puts parse_error_paths
        puts
      end
  end
end
