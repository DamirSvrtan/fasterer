require 'ruby_parser'
require 'pry'

parser = RubyParser.new.parse("for number in [*1..100] do\n number\n end")

binding.pry
