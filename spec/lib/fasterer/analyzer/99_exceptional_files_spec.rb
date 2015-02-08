require 'spec_helper'

describe Fasterer::Analyzer do

  let(:test_file_path) { RSpec.root.join('support', '99_exceptional_files', 'main.rb') }

  it 'should detect gsub 4 times' do
    analyzer = Fasterer::Analyzer.new(test_file_path)
    expect { analyzer.scan }.to raise_error(Fasterer::ParseError)
  end
end
