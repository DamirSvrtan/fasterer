require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '25_select_last_vs_reverse_detect.rb') }

  it 'should detect select last once' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:select_last_vs_reverse_detect].count).to eq(1)
  end
end
