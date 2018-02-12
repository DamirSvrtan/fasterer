require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end

require 'fasterer'
require 'fasterer/cli'
require 'fasterer/offense_list'
require 'pry'
require 'rspec-benchmark'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |f| require f }

def RSpec.root
  @root_path = Pathname.new(File.dirname(__FILE__))
end

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    allow_any_instance_of(Fasterer::FileTraverser).to receive(:puts).and_return(nil)
  end
end
