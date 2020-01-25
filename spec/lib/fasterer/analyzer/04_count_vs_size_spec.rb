require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '04_count_vs_size.rb') }

  it 'should detect count without argument or block once' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:count_vs_size].count).to eq(3)
  end
end
