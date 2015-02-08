module Fasterer
  class ParseError < StandardError

    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
      super("Unable to read #{file_path}")
    end

  end
end
