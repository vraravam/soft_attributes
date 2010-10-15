require File.dirname(__FILE__) + '/../spec_helper'

class Foo
  include SoftAttributes::NoopSetter
  include SoftAttributes::Base

  soft_attribute :vijay, :include_in_xml => Proc.new{ |r| r.application =~ /vij/i }, :value => Proc.new{ |r| "#{r.name} : #{r.application}" }

  attr_accessor :name, :application
end

describe SoftAttributes::Base do
  it "should define noop setters for a single attribute" do
    foo = Foo.new
    foo.respond_to?("vijay=").should be_true
  end

  it "should raise an error if unknown attributes are passed" do
    lambda {
      Foo.send(:soft_attribute, :john, :invalid_key1 => "some value 1", :invalid_key2 => "some value 2")
    }.should raise_error(ArgumentError, "Unknown key(s): invalid_key1, invalid_key2")
  end

  it "should invoke the provided getter method" do
    foo = Foo.new
    foo.name = "my name"
    foo.application = 'testing soft_attributes'
    foo.vijay.should == "my name : testing soft_attributes"
  end

  it "should discard the value from the setter and re-evaluate the getter" do
    foo = Foo.new
    foo.name = "my name"
    foo.application = 'testing soft_attributes'
    foo.vijay = "discarded value"
    foo.vijay.should == "my name : testing soft_attributes"
  end
end
