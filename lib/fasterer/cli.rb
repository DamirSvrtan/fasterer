require_relative 'file_traverser'

module Fasterer
  class CLI
    def self.execute(start_path ='.')
      file_traverser = Fasterer::FileTraverser.new(start_path)
      file_traverser.traverse
      abort if file_traverser.offenses_found?
    end
  end
end
