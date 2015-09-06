require 'rspec'
require 'spec_helper'
require_relative '../src/aspects'

class Foo
  extend Origin
  include Origin

  def m1_foo
  end

  def m2_foo
  end

end

class Bar
  extend Origin

  def m1_bar
  end

end

module Moo
  extend Origin
end

describe 'Aspects' do

  before(:all) do
    Regexp.send(:include, Origin)
    @foo = Foo.new
  end

  describe '#do' do

    context 'is able to handle' do

      it 'a Class' do
        Aspects.on Foo do end
      end

      it 'an object' do
        Aspects.on @foo do end
      end

      it 'a Module' do
        Aspects.on Moo do end
      end

      it 'a valid Regexp' do
        Aspects.on /Foo/ do end
      end

      it 'a valid Regexp along an invalid Regexp' do
        Aspects.on /ClaseQueNoExiste/, /Foo/ do end
      end

      it 'an object, a Regexp, a Class and a Module' do
        Aspects.on @foo, /Foo/, Bar, Moo do end
      end

    end

    context 'throws an ArgumentError' do

      it 'when an Origin doesn\'t exist' do
        expect { Aspects.on /ClaseQueNoExiste/ do end }.to raise_error ArgumentError
      end

      it 'when passing zero arguments' do
        expect { Aspects.on do end }.to raise_error ArgumentError
      end

   end

 end

 describe '#where' do

   context 'is able to handle' do

     it 'a single name selector using a Class' do
       array = Aspects.on Foo do
         where name(/m1_foo/)
       end
       expect(array).to eq [:m1_foo]
     end

     it 'a single name selector using an object' do
       array = Aspects.on @foo do
         where name(/m1_foo/)
       end
       expect(array).to eq [:m1_foo]
     end

   end

 end

end
