require 'rspec'
require_relative '../src/aspects'
require_relative 'data/fixture_for_integration_specs'
require_relative '../src/with_transformations'


describe 'AOP example' do
  un_espadachin = Espadachin.new(Espada.new 100)

  Aspects.on Kamikaze, Defensor, un_espadachin do
    transform(where names(/^atacar$/)) do
      instead do
        'Surprise!'
      end
    end
  end

  it do
    expect(un_espadachin.atacar).to eql 'Surprise!'
  end

  it do
    expect(Kamikaze.new.atacar).to eql 'Surprise!'
  end

  it do
    expect{Espadachin.new.atacar}.to raise_error ArgumentError
  end

end


