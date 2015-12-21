require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '13_sort_vs_sort_by.rb') }

  it 'should detect sort once' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:sort_vs_sort_by].count).to eq(1)
  end
end
