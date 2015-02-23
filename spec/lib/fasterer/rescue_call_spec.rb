require 'spec_helper'

describe Fasterer::RescueCall do

  let(:rescue_element) do
    sexpd_file = Fasterer::Parser.parse(File.read(RSpec.root.join('support', 'rescue_call', file_name)))
    sexpd_file[2]
  end

  let(:rescue_call) do
    Fasterer::RescueCall.new(rescue_element)
  end

  describe 'plain rescue call' do

    let(:file_name) { 'plain_rescue.rb' }

    it 'should detect constant' do
      expect(rescue_call.rescue_classes).to eq([])
    end

  end

  describe 'rescue call with class' do

    let(:file_name) { 'rescue_with_class.rb' }

    it 'should detect integer' do
      expect(rescue_call.rescue_classes).to eq([:NoMethodError])
    end

  end

  describe 'rescue call with class and variable' do

    let(:file_name) { 'rescue_with_class_and_variable.rb' }

    it 'should detect string' do
      expect(rescue_call.rescue_classes).to eq([:NoMethodError])
    end

  end

  describe 'rescue call with variable' do

    let(:file_name) { 'rescue_with_variable.rb' }

    it 'should detect variable' do
      expect(rescue_call.rescue_classes).to eq([])
    end

  end

  describe 'rescue call with multiple classes' do

    let(:file_name) { 'rescue_with_multiple_classes.rb' }

    it 'should detect method' do
      expect(rescue_call.rescue_classes).to eq([:NoMethodError, :StandardError])
    end

  end

  describe 'rescue call with multiple classes and variable' do

    let(:file_name) { 'rescue_with_multiple_classes_and_variable.rb' }

    it 'should detect method' do
      expect(rescue_call.rescue_classes).to eq([:NoMethodError, :StandardError])
    end

  end

end
