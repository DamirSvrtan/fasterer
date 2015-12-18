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

    context 'missing exclude_paths key' do
      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    ['speedups:'])
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns nil_config_file' do
        expect(file_traverser.config_file)
          .to eq(file_traverser.send(:nil_config_file))
      end
    end

    context 'with speedups content but no exclude_paths' do
      let(:config_file_content) do
        "speedups:\n"\
        "  keys_each_vs_each_key: true"
      end

      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    config_file_content)
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns config_file with added exclude paths key' do
        expect(file_traverser.config_file)
          .to eq('speedups' => { 'keys_each_vs_each_key' => true },
                 'exclude_paths' => [])
      end
    end

    context 'with exclude_paths content but no speedups' do
      let(:config_file_content) do
        "exclude_paths:\n"\
        "  - 'spec/support/analyzer/*.rb'"
      end

      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    config_file_content)
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns config_file with added speedups key' do
        expect(file_traverser.config_file)
          .to eq('speedups' => {},
                 'exclude_paths' => ['spec/support/analyzer/*.rb'])
      end
    end

    context 'with exclude_paths and speedups content' do
      let(:config_file_content) do
        "speedups:\n"\
        "  keys_each_vs_each_key: true\n"\
        "exclude_paths:\n"\
        "  - 'spec/support/analyzer/*.rb'"
      end

      before(:each) do
        create_file(Fasterer::FileTraverser::CONFIG_FILE_NAME,
                    config_file_content)
      end

      let(:file_traverser) { Fasterer::FileTraverser.new('.') }

      it 'returns config_file' do
        expect(file_traverser.config_file)
          .to eq('speedups' => { 'keys_each_vs_each_key' => true },
                 'exclude_paths' => ['spec/support/analyzer/*.rb'])
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
