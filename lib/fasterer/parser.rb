module Fasterer
  class Parser

    PARSER_CLASS = Ripper

    def self.parse(ruby_code)
      PARSER_CLASS.sexp(ruby_code)
    end

  end
end
