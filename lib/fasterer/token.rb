module Fasterer
  class Token
    def initialize(name)
      @name = name
    end

    def method_definition?
      name == :def
    end

    def method_call?
      name == :call
    end

    def command_call?
      name == :command
    end

    def parallel_assignment?
      name == :massign
    end

    def for_loop?
      name == :for
    end
  end
end
