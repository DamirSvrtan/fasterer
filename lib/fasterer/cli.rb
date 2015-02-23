require_relative 'file_traverser'

module Fasterer
  class CLI
    def self.execute
      file_traverser = Fasterer::FileTraverser.new('.')
      file_traverser.traverse
    end
  end
end
