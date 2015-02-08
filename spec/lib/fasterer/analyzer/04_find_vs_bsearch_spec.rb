require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '04_find_vs_bsearch', 'main.rb') }

  xit 'should detect Array#find' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    analyzer.scan
    # expect(analyzer.error_occurrence[:module_eval]).to eq(1)
  end
end
