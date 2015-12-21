require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '11_reverse_each_vs_reverse_each.rb') }

  it 'should detect a for loop' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:reverse_each_vs_reverse_each].count).to eq(2)
  end
end
