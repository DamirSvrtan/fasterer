require_relative 'file_traverser'

module Fasterer
  class CLI
    def self.execute
      file_traverser = Fasterer::FileTraverser.new(ARGV[0])
      file_traverser.traverse
      abort if file_traverser.offenses_found?
    end
  end
end
