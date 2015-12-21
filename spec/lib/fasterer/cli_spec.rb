require 'spec_helper'

describe Fasterer::FileTraverser do
  include FileHelper
  include_context 'isolated environment'

  describe 'exit status should be' do
    context 'success' do
      it 'when no files exist' do
        `#{fasterer_bin}`
        expect($CHILD_STATUS.exitstatus).to eq(0)
      end

      it 'when no files with offenses exist' do
        create_file('user.rb', '[].sample')
        `#{fasterer_bin}`
        expect($CHILD_STATUS.exitstatus).to eq(0)
      end
    end

    context 'fail' do
      it 'when file with offenses exists' do
        create_file('user.rb', '[].shuffle.first')
        `#{fasterer_bin}`
        expect($CHILD_STATUS.exitstatus).to eq(1)
      end
    end
  end

  def fasterer_bin
    File.expand_path('../../../../bin/fasterer', __FILE__)
  end
end
