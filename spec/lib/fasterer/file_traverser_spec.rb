require 'spec_helper'

describe Fasterer::FileTraverser do
  include FileHelper
  include_context 'isolated environment'

  describe 'config_file' do
    context 'with no config file' do
      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns nil_config_file' do
        expect(file_traverser.config_file)
          .to eq(file_traverser.send(:nil_config_file))
      end
    end

    context 'with empty config file' do
      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME, '')
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns nil_config_file' do
        expect(file_traverser.config_file)
          .to eq(file_traverser.send(:nil_config_file))
      end
    end

    context 'with empty values' do
      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    ['speedups:',
                     '',
                     'exclude_paths:'])
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns nil_config_file' do
        expect(file_traverser.config_file)
          .to eq(file_traverser.send(:nil_config_file))
      end
    end
  end
end
