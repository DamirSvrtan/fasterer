module Fasterer
  class InlineSpeedupScanner
    COMMENT_REGEX = /#\s*fasterer:(?<status>disable|enable) (?<offence>[a-z_]+)/

    def initialize
      @store = {}
    end

    def scan(token)
      return unless (match_data = token&.match(COMMENT_REGEX))

      status = match_data[:status]
      @store[status] ||= []
      save_offence(status, match_data[:offence])
    end

    def enabled_offense?(offence_name)
      @store.fetch(:enable, []).include?(offence_name)
    end

    def disabled_offense?(offence_name)
      @store.fetch(:disable, []).include?(offence_name)
    end

    private

    def save_offence(status, offence)
      @store.each_key do |stored_status|
        next if stored_status == status

        @store[stored_status].reject! { |stored_offence| stored_offence == offence }
      end

      @store[status] << offence
      @store[status].uniq!
    end
  end
end