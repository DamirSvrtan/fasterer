require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '09_each_with_index_vs_while.rb') }

  it 'should detect a for loop' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:each_with_index_vs_while].count).to eq(1)
  end
end
