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

  def m1_moo
  end

  def m2_moo
  end

end

describe 'Aspects' do

  let(:foo) { Foo.new }

  before(:all) do
    Object.send(:include, Origin)
    Class.send(:include, Origin)
    Regexp.send(:include, Origin)
    Module.send(:include, Origin)
  end

  describe '#do' do

    context 'is able to handle' do

      it 'a Class' do
        Aspects.on Foo do end
      end

      it 'an object' do
        Aspects.on foo do end
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
        Aspects.on foo, /Foo/, Bar, Moo do end
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
       array = Aspects.on foo do
         where name(/m1_foo/)
       end
       expect(array).to eq [:m1_foo]
     end

     it 'several name selectors using an object' do
       array = Aspects.on foo do
         where name(/m1_foo/), name(/m2_foo/)
       end
       expect(array).to eq [:m1_foo, :m2_foo]
     end

     it 'several name selectors using a Class' do
       array = Aspects.on Bar do
         where name(/m1/)
       end
       expect(array).to eq [:m1_bar]
     end

     it 'several name selectors using several classes' do
       array = Aspects.on Foo, Bar do
         where name(/m/)
       end
       expect(array.sort).to eq [:m1_foo, :m2_foo, :m1_bar].sort
     end

     it 'several redundant name selectors using modules and classes' do
       array = Aspects.on Moo, Bar do
         where name(/m/), name(/m/), name(/m/), name(/m/)
       end
       expect(array.sort).to eq [:m1_bar, :m1_moo, :m2_moo].sort
     end

     it 'anything using several regexes' do
       array = Aspects.on /\bFoo\b/, /\bBar\b/, /\bMoo\b/ do
         where name(//)
       end
       expect(array.sort).to eq [:m1_foo, :m2_foo, :m1_bar, :m1_moo, :m2_moo].sort
     end

     it 'a negation on a name selector' do
       array = Aspects.on Foo do
         where neg(name(/1/))
       end
       expect(array).to eq [:m2_foo]
     end

     it 'a double negation on a name selector' do
       array = Aspects.on Foo do
         where neg(neg(name(/1/)))
       end
       expect(array).to eq [:m1_foo]
     end

   end

 end

end
