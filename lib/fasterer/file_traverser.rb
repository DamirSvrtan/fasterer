require 'pathname'
require 'colorize'
require 'yaml'

require_relative 'analyzer'

module Fasterer
  class FileTraverser

    CONFIG_FILE_NAME = '.fasterer.yml'

    attr_reader :ignored_speedups

    def initialize(path)
      @path = Pathname(path)
      @parse_error_paths = []
      set_ignored_speedups
    end

    def traverse
      if @path.directory?
        traverse_directory(@path)
      else
        scan_file(@path)
      end
      output_parse_errors if parse_error_paths.any?
    end

    def set_ignored_speedups
      @ignored_speedups = if config_file
        config_file['speedups'].select {|_, value| value == false }.keys.map(&:to_sym)
      end || []
    end

    def config_file
      File.exists?(CONFIG_FILE_NAME) && YAML.load_file(CONFIG_FILE_NAME)
    end

    private

    attr_reader :parse_error_paths

    def scan_file(path)
      analyzer = Analyzer.new(path)
      analyzer.scan
    rescue Fasterer::ParseError, RubyParser::SyntaxError, Racc::ParseError
      parse_error_paths.push(path)
    else
      output(analyzer) if offenses_grouped_by_type(analyzer).any?
    end

    def traverse_directory(path)
      Dir["#{path}/**/*.rb"].each do |ruby_file|
        scan_file(ruby_file.split('/').drop(1).join('/'))
      end
    end

    def output(analyzer)
      puts analyzer.file_path.colorize(:red)

      offenses_grouped_by_type(analyzer).each do |error_group_name, error_occurences|
        puts "#{Fasterer::Offense::EXPLANATIONS[error_group_name]}. Occured at lines: #{error_occurences.map(&:line_number).join(', ')}."
      end

      puts
    end

    def offenses_grouped_by_type(analyzer)
      analyzer.errors.group_by(&:name).delete_if {|offense_name, _| ignored_speedups.include?(offense_name) }
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
