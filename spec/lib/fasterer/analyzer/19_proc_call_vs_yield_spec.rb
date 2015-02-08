require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '19_proc_call_vs_yield', 'main.rb') }

  it 'should detect sort once' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.error_occurrence[:proc_call_vs_yield]).to eq(3)
  end
end
