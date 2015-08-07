require_relative 'file_traverser'

module Fasterer
  class CLI
    def self.execute(start_path ='.')
      file_traverser = Fasterer::FileTraverser.new(start_path)
      file_traverser.traverse
    end
  end
end
