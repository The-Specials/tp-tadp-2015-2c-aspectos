require 'rspec'
require_relative '../src/aspects'
require 'mega_evil'

describe 'Condiciones test' do

  it 'name devuelve los metodos que matchean con la regex' do
    evol = Mega_evil.new
    Aspects.set_origen evol
    expect(Aspects.get_methods). to eq [:evil_method]
    Aspects.name /^e/
    expect(Aspects.name /^a/). to eq [:evil_method]

  end

end

