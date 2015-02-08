require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '02_rescue_vs_respond_to', 'main.rb') }

  it 'should detect rescue NoMethodError' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    expect(analyzer.error_occurrence[:rescue_vs_respond_to]).to eq(3)
  end
end
