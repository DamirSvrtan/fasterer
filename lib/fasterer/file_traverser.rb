require 'pathname'
require 'colorize'
require 'yaml'

require_relative 'analyzer'

module Fasterer
  class FileTraverser

    CONFIG_FILE_NAME = '.fasterer.yml'

    SPEEDUPS_KEY = 'speedups'

    EXCLUDE_PATHS_KEY = 'exclude_paths'

    attr_reader :ignored_speedups, :ignored_paths

    def initialize(path)
      @path = Pathname(path)
      @parse_error_paths = []
      set_ignored_speedups
      set_ignored_paths
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
      @ignored_speedups = if config_file && config_file[SPEEDUPS_KEY]
        config_file[SPEEDUPS_KEY].select {|_, value| value == false }.keys.map(&:to_sym)
      end || []
    end

    def set_ignored_paths
      @ignored_paths = if config_file && config_file[EXCLUDE_PATHS_KEY]
        config_file[EXCLUDE_PATHS_KEY].flat_map {|path| Dir[path] }
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
    rescue RubyParser::SyntaxError, Racc::ParseError
      parse_error_paths.push(path)
    else
      output(analyzer) if offenses_grouped_by_type(analyzer).any?
    end

    def traverse_directory(path)
      Dir["#{path}/**/*.rb"].each do |ruby_file_path|
        relative_ruby_file_path = Pathname(ruby_file_path).relative_path_from(path)
        unless ignored_paths.include?(relative_ruby_file_path.to_s)
          scan_file(relative_ruby_file_path)
        end
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
