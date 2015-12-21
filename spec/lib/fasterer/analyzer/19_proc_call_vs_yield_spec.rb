require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '19_proc_call_vs_yield.rb') }

  it 'should detect sort once' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.errors[:proc_call_vs_yield].count).to eq(3)
  end
end
