require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '14_fetch_with_argument_vs_block.rb') }

  it 'should detect keys fetch with argument once' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:fetch_with_argument_vs_block].count).to eq(1)
  end
end
