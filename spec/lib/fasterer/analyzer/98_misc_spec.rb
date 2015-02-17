require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '98_misc', 'main.rb') }

  it 'should detect gsub 4 times' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
  end
end
