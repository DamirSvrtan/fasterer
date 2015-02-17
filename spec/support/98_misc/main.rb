1.describe('method call with an argument and a block') do

  let(:file_name) { 'method_call_with_an_argument_and_a_block.rb' }

  let(:call_element) { ripper.drop(1).first.last }

  it 'should detect argument and a block' do
    expect(method_call.method_name).to eq('fetch')
    expect(method_call.arguments.count).to eq(1)
    expect(method_call.arguments.first.type).to eq(:symbol_literal)
    expect(method_call.has_block?).to be
    expect(method_call.receiver).to be_a(Fasterer::VariableReference)
  end

end
