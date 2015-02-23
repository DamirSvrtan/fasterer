require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '01_parallel_assignment.rb') }

  it 'should detect parallel assignment 2 times' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:parallel_assignment].count).to eq(2)
  end
end
