require File.dirname(__FILE__) + '/../spec_helper'

class Foo
  include SoftAttributes::NoopSetter

  noop_setter :foo
  noop_setter :bar, :baz
end

describe SoftAttributes::NoopSetter do
  it "should define noop setters for a single attribute" do
    ["foo=", "bar=", "baz="].each do |method|
      Foo.public_instance_methods.include?(method).should be_true
    end
  end

  it "should accept parameters for the generated setter methods" do
    f = Foo.new
    lambda {
      f.foo = "qwerty"
      f.bar = "asdfg"
      f.baz = "zxcvb"
    }.should_not raise_error
  end
end
