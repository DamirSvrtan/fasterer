require 'pathname'
require 'colorize'
require 'English'

require_relative 'analyzer'
require_relative 'config'

module Fasterer
  class FileTraverser
    CONFIG_FILE_NAME  = Config::FILE_NAME
    SPEEDUPS_KEY      = Config::SPEEDUPS_KEY
    EXCLUDE_PATHS_KEY = Config::EXCLUDE_PATHS_KEY

    attr_reader :config
    attr_reader :parse_error_paths
    attr_accessor :offenses_total_count

    def initialize(path)
      @path = Pathname(path)
      @parse_error_paths = []
      @config = Config.new
      @offenses_total_count = 0
    end

    def traverse
      if @path.directory?
        scannable_files.each { |ruby_file| scan_file(ruby_file) }
      else
        scan_file(@path)
      end
      output_parse_errors if parse_error_paths.any?
      output_statistics
    end

    def config_file
      config.file
    end

    def offenses_found?
      !!offenses_found
    end

    def scannable_files
      all_files - ignored_files
    end

    private

    attr_accessor :offenses_found

    def scan_file(path)
      analyzer = Analyzer.new(path)
      analyzer.scan
    rescue RubyParser::SyntaxError, Racc::ParseError, Timeout::Error => e
      parse_error_paths.push(ErrorData.new(path, e.class, e.message).to_s)
    else
      if offenses_grouped_by_type(analyzer).any?
        output(analyzer)
        self.offenses_found = true
        self.offenses_total_count += analyzer.errors.count
      end
    end

    def all_files
      Dir["#{@path}/**/*.rb"].map do |ruby_file_path|
        Pathname(ruby_file_path).to_s
      end
    end

    def output(analyzer)
      puts analyzer.file_path.colorize(:red)

      offenses_grouped_by_type(analyzer).each do |error_group_name, error_occurences|
        puts "#{Fasterer::Offense::EXPLANATIONS[error_group_name]}."\
             " Occurred at lines: #{error_occurences.map(&:line_number).join(', ')}."
      end

      puts
    end

    def offenses_grouped_by_type(analyzer)
      analyzer.errors.group_by(&:name).delete_if do |offense_name, _|
        ignored_speedups.include?(offense_name)
      end
    end

    def output_parse_errors
      puts 'Fasterer was unable to process some files because the'
      puts 'internal parser is not able to read some characters or'
      puts 'has timed out. Unprocessable files were:'
      puts '-----------------------------------------------------'
      puts parse_error_paths
      puts
    end

    def output_statistics
      puts Statistics.new(self)
    end

    def ignored_speedups
      config.ignored_speedups
    end

    def ignored_files
      config.ignored_files
    end

    def nil_config_file
      config.nil_file
    end
  end

  ErrorData = Struct.new(:file_path, :error_class, :error_message) do
    def to_s
      "#{file_path} - #{error_class} - #{error_message}"
    end
  end

  class Statistics
    def initialize(traverser)
      @files_inspected_count  = traverser.scannable_files.count
      @offenses_found_count   = traverser.offenses_total_count
      @unparsable_files_count = traverser.parse_error_paths.count
    end

    def to_s
      [
        inspected_files_output,
        offenses_found_output,
        unparsable_files_output
      ].compact.join(', ')
    end

    def inspected_files_output
      "#{@files_inspected_count} #{pluralize(@files_inspected_count, 'file')} inspected"
        .colorize(:green)
    end

    def offenses_found_output
      "#{@offenses_found_count} #{pluralize(@offenses_found_count, 'offense')} detected"
        .colorize(:red)
    end

    def unparsable_files_output
      return if @unparsable_files_count.zero?
      "#{@unparsable_files_count} unparsable #{pluralize(@unparsable_files_count, 'file')} found"
        .colorize(:red)
    end

    def pluralize(n, singular, plural = nil)
      if n == 1
        "#{singular}"
      elsif plural
        "#{plural}"
      else
        "#{singular}s"
      end
    end
  end
end
