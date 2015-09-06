require 'rspec'
require_relative '../src/aspects'

describe 'Aspects test' do

    it 'me permite definirle un origen' do
      MiClase = Class.new
      expect{Aspects.on MiClase do end}.not_to raise_error(ArgumentError)
      expect(Aspects.origen). to eq ([MiClase])
    end

    it 'si no le paso ningun origen tira error' do
      expect{Aspects.on}.to raise_error(ArgumentError)
    end
end
