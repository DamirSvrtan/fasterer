require 'spec_helper'

describe Fasterer::Analyzer do
  let(:test_file_path) { RSpec.root.join('support', 'analyzer', '99_exceptional_files.rb') }

  it 'diacritics should not raise an error' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    expect { analyzer.scan }.not_to raise_error
  end
end
