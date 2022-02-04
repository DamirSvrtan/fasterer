module Fasterer
  class InlineSpeedupScanner
    COMMENT_REGEX = /#\s*fasterer:(?<status>disable|enable) (?<speedup>[a-z_]+)/

    def initialize
      @store = {}
    end

    def scan(file_content)
      file_content.split("\n").each_with_index do |line, line_num|
        next unless (match_data = line.match(COMMENT_REGEX))

        @current_line = line_num + 1 # line_num starts with zero
        status = match_data[:status]
        @store[status] ||= []
        store_speedup(status, match_data[:speedup])
      end
    end

    def enabled_speedup?(offense)
      enabled_speedup = speedup_by_status_and_name('enable', offense.name.to_s)
      return false unless enabled_speedup

      enabled_speedup[:context].cover?(offense.line_number)
    end

    def disabled_speedup?(offense)
      disabled_speedup = speedup_by_status_and_name('disable', offense.name.to_s)
      return false unless disabled_speedup

      disabled_speedup[:context].cover?(offense.line_number)
    end

    private

    def store_speedup(status, speedup)
      limit_saved_speedups_context(status, speedup)

      saved_speedup = speedup_by_status_and_name(status, speedup)
      # Only unique status speedup available per file
      return if saved_speedup

      @store[status] << { name: speedup, context: (@current_line...) }
    end

    def limit_saved_speedups_context(status, speedup)
      saved_speedup = speedup_by_status_and_name(opposite_status(status), speedup)
      return unless saved_speedup

      saved_speedup[:context] = saved_speedup[:context].first...@current_line
    end

    def opposite_status(status)
      status == 'disable' ? 'enable' : 'disable'
    end

    def speedup_by_status_and_name(status, name)
      @store.fetch(status, []).find do |speedup_obj|
        speedup_obj[:name] == name
      end
    end
  end
end