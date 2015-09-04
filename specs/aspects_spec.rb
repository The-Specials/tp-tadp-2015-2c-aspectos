require 'rspec'
require_relative '../src/aspects'
require_relative 'data/origen_mocks'

describe Aspects do

  let(:origenValido) { Origen.new }
  let(:origenVacio) { OrigenVacio.new }

  describe '#on' do

    context 'when no arguments are passed' do
      it do
        expect{Aspects.on do end}.to raise_error(ArgumentError, 'wrong number of arguments (0 for 1+)')
      end
    end

    context 'when there are not any valid Origenes' do
      it do
        expect{Aspects.on(origenVacio) do end}.to raise_error(ArgumentError, 'origen vacio')
      end

      it do
        expect{Aspects.on(origenVacio, OrigenVacio.new, OrigenVacio.new) do end}.to raise_error(ArgumentError, 'origen vacio')
      end
    end

    context 'when there are at least one valid Origen' do
      it do
        expect(Aspects.on(origenValido) do end).to eq [1]
      end

      it do
        expect(Aspects.on(origenValido, origenVacio) do end).to eq [1]
      end
    end

  end
end


