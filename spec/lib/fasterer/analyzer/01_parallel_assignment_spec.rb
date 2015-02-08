require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '01_parallel_assignment', 'main.rb') }

  it 'should detect parallel assignment 2 times' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.error_occurrence[:parallel_assignment]).to eq(2)
  end
end
