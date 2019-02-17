require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '04_find_vs_bsearch_sample.rb') }

  it 'should detect a find' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:find_vs_bsearch].count).to eq(2)
  end
end
