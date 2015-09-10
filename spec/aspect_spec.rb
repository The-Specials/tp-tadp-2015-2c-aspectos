require 'rspec'
require_relative '../src/aspects'

describe 'Aspects test' do

    it 'Me permite definirle un origen' do
      MiClase = Class.new
      un_objeto = MiClase.new
      Good_class_555 = Class.new
      Evil_class_666 = Class.new
      Super_evil_module = Module.new
      Aspects.set_fuentes MiClase, Good_class_555, Evil_class_666, Super_evil_module
      Aspects.on MiClase, /^G/, /^S/ do end
      expect(Aspects.origen). to eq ([MiClase, Good_class_555, Super_evil_module])
    end

    it 'Si el origen es vacio tira error' do
      expect{Aspects.on}.to raise_error(ArgumentError)
    end

    it 'Si el origen es invalido tira error' do
      ClaseQueNoEstaEnFuente = Class.new
      Aspects.set_fuentes MiClase
      expect{Aspects.on ClaseQueNoEstaEnFuente}.to raise_error(ArgumentError)
    end

    it 'Me permite definir un origen si un origen no esta en la fuente y otro si' do
      Aspects.set_fuentes MiClase
      Aspects.on(ClaseQueNoEstaEnFuente, MiClase)
      expect(Aspects.origen). to eq ([MiClase])
    end

    it 'Me permite definir un origen a partir de una regex' do
      Aspects.set_fuentes Evil_class_666, MiClase
      Aspects.on /^E/, /^M/ do end
      expect(Aspects.origen). to eq [Evil_class_666, MiClase]
    end

end
