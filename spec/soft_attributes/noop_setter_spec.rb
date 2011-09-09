require File.expand_path('../../spec_helper', __FILE__)

class Bar
  include SoftAttributes::NoopSetter

  noop_setter :foo
  noop_setter :bar, :baz
end

describe SoftAttributes::NoopSetter do
  it "should define noop setters for a single attribute" do
    ["foo=", "bar=", "baz="].each do |method|
      Bar.public_instance_methods.include?(method.to_sym).should be_true
    end
  end

  it "should accept parameters for the generated setter methods" do
    f = Bar.new
    lambda {
      f.foo = "qwerty"
      f.bar = "asdfg"
      f.baz = "zxcvb"
    }.should_not raise_error
  end
end
