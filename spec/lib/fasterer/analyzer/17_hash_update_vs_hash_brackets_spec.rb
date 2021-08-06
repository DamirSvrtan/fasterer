require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '17_hash_update_vs_hash_brackets.rb') }

  it 'should detect keys each 3 times' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:hash_update_vs_hash_brackets].count).to eq(3)
  end
end
