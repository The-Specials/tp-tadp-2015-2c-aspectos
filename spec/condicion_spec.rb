require 'rspec'
require_relative '../src/aspects'
require_relative '../src/Condicion'


describe 'condicion test' do

  it 'name devuelve los metodos que matchean con la regex' do
    Evol = Class.new
    Aspects.set_fuentes Evol
    Aspects.on Evol do end
    expect(Aspects.get_methods). to eq [:evil_method]
  end

end


