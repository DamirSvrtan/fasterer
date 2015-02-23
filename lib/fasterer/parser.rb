require 'ruby_parser'

module Fasterer
  class Parser
    PARSER_CLASS = RubyParser

    def self.parse(ruby_code)
      PARSER_CLASS.new.parse(ruby_code)
    end
  end
end
