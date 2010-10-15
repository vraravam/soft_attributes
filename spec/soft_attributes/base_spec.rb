require File.dirname(__FILE__) + '/../spec_helper'

class Foo < ActiveRecord::Base
  soft_attribute :vijay, :include_in_xml => Proc.new{ |r| r.application =~ /vij/i }, :value => Proc.new{ |r| "#{r.name} : #{r.application}" }
  soft_attribute :sujay, :include_in_xml => Proc.new{ |r| r.application =~ /jay/i }, :value => Proc.new{ |r| "#{r.application} : #{r.name}" }
  soft_attribute :mythili, :include_in_xml => false, :value => Proc.new{ |r| "blah" }  # eg of non-Proc - evaluating always to false for xml
  soft_attribute :aravamudhan, :include_in_xml => true, :value => Proc.new{ |r| "kannan" }  # eg of non-Proc - evaluating always to true for xml

  def to_xml(opts={})
    super(opts) do |xml|
      xml.tag!(:krishna, "some other random stuff to test when blocks are present")
    end
  end
end

describe SoftAttributes::Base do
  before(:all) do
    connection = Foo.connection
    begin
      connection.create_table(:foos) do |t|
        t.string :name
        t.string :application
      end
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.warn "Error in before(:each): #{e}"
    end
  end

  after(:all) do
    begin
      Foo.connection.drop_table(Foo.table_name)
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.warn "Error in after(:each): #{e}"
    end
  end

  it "should define noop setters for a single attribute" do
    foo = Foo.new
    foo.respond_to?("vijay=").should be_true
  end

  it "should raise an error if unknown attributes are passed" do
    lambda {
      Foo.send(:soft_attribute, :john, :invalid_key1 => "some value 1", :invalid_key2 => "some value 2")
    }.should raise_error(ArgumentError) do |e|
      e.message.should match(/^Unknown key(s): /)
      e.message.should include("invalid_key1")
      e.message.should include("invalid_key2")
    end
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

  describe "to_xml" do
    it "should include all attributes that evaluate to true with both attributes using Procs evaluating to true" do
      foo = Foo.new(:name => "rakshita", :application => "vijay's demo")
      xml = foo.to_xml
      xml.should have_tag("name", foo.name)
      xml.should have_tag("vijay", "#{foo.name} : #{foo.application}")
      xml.should have_tag("sujay", "#{foo.application} : #{foo.name}")
      xml.should_not have_tag("mythili")
      xml.should have_tag("aravamudhan", "kannan")
    end

    it "should include all attributes (including the ones which do not use Procs)" do
      foo = Foo.new(:name => "rakshita", :application => "vijay's demo")
      xml = foo.to_xml
      xml.should have_tag("aravamudhan", "kannan")
    end

    it "should never include any attributes that evaluate to false" do
      foo = Foo.new(:name => "rakshita", :application => "vij's demo")
      xml = foo.to_xml
      xml.should have_tag("name", foo.name)
      xml.should have_tag("vijay", "#{foo.name} : #{foo.application}")
      xml.should_not have_tag("sujay")
      xml.should_not have_tag("mythili")
    end
  end
end
