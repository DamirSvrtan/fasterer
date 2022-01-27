module Fasterer
  class InlineSpeedupScanner
    COMMENT_REGEX = /#\s*fasterer:(?<status>disable|enable) (?<offence>[a-z_]+)/

    def initialize
      @store = {}
    end

    def scan(file_content)
      file_content.split("\n").each do |line|
        next unless (match_data = line.match(COMMENT_REGEX))

        status = match_data[:status]
        @store[status] ||= []
        save_offense(status, match_data[:offence])
      end
    end

    def enabled_offense?(offense_name)
      @store.fetch('enable', []).include?(offense_name.to_s)
    end

    def disabled_offense?(offense_name)
      @store.fetch('disable', []).include?(offense_name.to_s)
    end

    private

    def save_offense(status, offence)
      @store.each_key do |stored_status|
        next if stored_status == status

        @store[stored_status].reject! { |stored_offence| stored_offence == offence }
      end

      @store[status] << offence
      @store[status].uniq!
    end
  end
end