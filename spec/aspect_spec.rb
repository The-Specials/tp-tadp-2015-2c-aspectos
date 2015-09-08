require 'rspec'
require_relative '../src/aspects'

describe 'Aspects test' do

    it 'me permite definirle un origen con una clase' do
      MiClase = Class.new
      Aspects.set_fuentes MiClase
      Aspects.on MiClase do end
      expect(Aspects.origen). to eq ([MiClase])
    end

    it 'si no le paso ningun origen tira error' do
      expect{Aspects.on}.to raise_error(ArgumentError)
    end

    it 'si le paso un origen invalido tira error' do
      ClaseQueNoEstaEnFuente = Class.new
      Aspects.set_fuentes MiClase
      expect{Aspects.on ClaseQueNoEstaEnFuente}.to raise_error(ArgumentError)
    end

    it 'si le paso una clase que no esta en la fuente y otra que si me lo permite' do
      Aspects.set_fuentes MiClase
      Aspects.on(ClaseQueNoEstaEnFuente, MiClase)
      expect(Aspects.origen). to eq ([MiClase])
    end

    it 'me permite definirle un origen' do
      Foolish = Class.new
      Aspects.set_fuentes Foolish, MiClase
      Aspects.on(Foolish, MiClase) do end
      expect(Aspects.origen). to include(MiClase, Foolish)
    end

end
